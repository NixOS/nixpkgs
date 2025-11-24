{
  lib,
  stdenv,
  makeWrapper,
  buildEnv,
  factor-unwrapped,
  cairo,
  freealut,
  gdk-pixbuf,
  glib,
  gnome2,
  gtk2-x11,
  libGL,
  libGLU,
  librsvg,
  graphviz,
  libogg,
  libvorbis,
  openal,
  openssl,
  pango,
  pcre,
  udis86,
  zlib,
  # Enable factor GUI support
  guiSupport ? true,
  # Libraries added to ld.so.cache
  extraLibs ? [ ],
  # Packages added to path (and ld.so.cache)
  binPackages ? [ ],
  # Extra vocabularies added to out/lib/factor
  extraVocabs ? [ ],
  # Enable default libs and bins to run most of the standard library code.
  enableDefaults ? true,
  doInstallCheck ? true,
}:
let
  inherit (lib) optional optionals optionalString;
  # missing from lib/strings
  escapeNixString = s: lib.escape [ "$" ] (builtins.toJSON s);
  toFactorArgs = x: lib.concatStringsSep " " (map escapeNixString x);
  defaultLibs = optionals enableDefaults [
    libogg
    libvorbis
    openal
    openssl
    pcre
    udis86
    zlib
  ];
  defaultBins = optionals enableDefaults [ graphviz ];
  runtimeLibs =
    defaultLibs
    ++ extraLibs
    ++ binPackages
    ++ (lib.flatten (map (v: v.extraLibs or [ ]) extraVocabs))
    ++ optionals guiSupport [
      cairo
      freealut
      gdk-pixbuf
      glib
      gnome2.gtkglext
      gtk2-x11
      libGL
      libGLU
      pango
    ];
  bins = binPackages ++ defaultBins ++ (lib.flatten (map (v: v.extraPaths or [ ]) extraVocabs));
  vocabTree = buildEnv {
    name = "${factor-unwrapped.pname}-vocabs";
    ignoreCollisions = true;
    pathsToLink = map (r: "/lib/factor/${r}") [
      "basis"
      "core"
      "extra"
    ];
    paths = [ factor-unwrapped ] ++ extraVocabs;
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "${factor-unwrapped.pname}-env";
  inherit (factor-unwrapped) version;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = optional guiSupport gdk-pixbuf;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
  ''
  + optionalString guiSupport ''
    # Set Gdk pixbuf loaders file to the one from the build dependencies here
    unset GDK_PIXBUF_MODULE_FILE
    # Defined in gdk-pixbuf setup hook
    findGdkPixbufLoaders "${librsvg}"
    makeWrapperArgs+=(--set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE")
  ''
  + ''
    makeWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:${lib.makeLibraryPath runtimeLibs}
      --prefix PATH : ${lib.makeBinPath bins})
    mkdir -p "$out/bin" "$out/share"
    cp -r "${factor-unwrapped}/lib" "$out/"
    cp -r "${factor-unwrapped}/share/emacs" "$out/share/"
    chmod -R u+w "$out/lib" "$out/share"
    (
        cd ${vocabTree}
        for f in "lib/factor/"* ; do
            rm -r "$out/$f"
            ln -s "${vocabTree}/$f" "$out/$f"
        done
    )

    # There is no ld.so.cache in NixOS so we construct one
    # out of known libraries. The side effect is that find-lib
    # will work only on the known libraries. There does not seem
    # to be a generic solution here.
    find $(echo ${
      lib.makeLibraryPath ([ stdenv.cc.libc ] ++ runtimeLibs)
    } | sed -e 's#:# #g') -name \*.so.\* > $TMPDIR/so.lst
    (echo $(cat $TMPDIR/so.lst | wc -l) "libs found in cache \`/etc/ld.so.cache'";
      for l in $(<$TMPDIR/so.lst); do
        echo " $(basename $l) (libc6,x86-64) => $l";
      done)> $out/lib/factor/ld.so.cache

    # Create a wrapper in bin/ and lib/factor/
    wrapProgram "$out/lib/factor/factor" \
      --argv0 factor \
      --set FACTOR_LD_SO_CACHE "$out/lib/factor/ld.so.cache" \
      "''${makeWrapperArgs[@]}"
    mv $out/lib/factor/factor.image $out/lib/factor/.factor-wrapped.image
    cp $out/lib/factor/factor $out/bin/

    # Emacs fuel expects the image being named `factor.image` in the factor base dir
    ln -rs $out/lib/factor/.factor-wrapped.image $out/lib/factor/factor.image

    # Update default paths in fuel-listener.el to new output
    sed -E -i -e 's#(\(defcustom fuel-factor-root-dir ").*(")#'"\1$out/lib/factor\2#" \
        "$out/share/emacs/site-lisp/fuel-listener.el"
    runHook postInstall
  '';

  inherit doInstallCheck;
  disabledTests = toFactorArgs [
    "io.files.info.unix"
    "io.launcher.unix"
    "io.ports"
    "io.sockets"
    "io.sockets.unix"
    "io.sockets.secure.openssl"
    "io.sockets.secure.unix"
  ];
  installCheckPhase = ''
    runHook preInstallCheck

    export HOME=$TMPDIR
    $out/bin/factor -e='USING: tools.test tools.test.private
      zealot.factor sequences namespaces formatting ;
      zealot-core-vocabs
      { ${finalAttrs.disabledTests} } without
      "compiler" suffix
      [ test-vocab ] each :test-failures
      test-failures get length "Number of failed tests: %d\n" printf'

    runHook postInstallCheck
  '';

  passthru = {
    inherit
      defaultLibs
      defaultBins
      extraLibs
      runtimeLibs
      binPackages
      extraVocabs
      ;
  };

  meta = factor-unwrapped.meta // {
    mainProgram = "factor";
  };
})
