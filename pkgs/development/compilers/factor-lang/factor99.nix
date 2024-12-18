{ lib
, stdenv
, cairo
, curl
, fetchurl
, freealut
, gdk-pixbuf
, git
, glib
, gnome2
, graphviz
, gtk2-x11
, interpreter
, libGL
, libGLU
, libogg
, librsvg
, libvorbis
, makeWrapper
, ncurses
, openal
, openssl
, pango
, pcre
, runCommand
, runtimeShell
, tzdata
, udis86
, unzip
, writeScriptBin
, zlib
}:
let
  runtimeLibs = [
    cairo
    freealut
    gdk-pixbuf
    glib
    gnome2.gtkglext
    graphviz
    gtk2-x11
    libGL
    libGLU
    libogg
    libvorbis
    openal
    openssl
    pango
    pcre
    udis86
    zlib
  ];

  wrapFactorScript = { from, to ? false, runtimeLibs }: ''
    # Set Gdk pixbuf loaders file to the one from the build dependencies here
    unset GDK_PIXBUF_MODULE_FILE
    # Defined in gdk-pixbuf setup hook
    findGdkPixbufLoaders "${librsvg}"

    ${if (builtins.isString to) then "makeWrapper ${from} ${to}" else "wrapProgram ${from}"} \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --argv0 factor \
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:${lib.makeLibraryPath runtimeLibs} \
      --prefix PATH : ${lib.makeBinPath [ graphviz ]}
  '';

  wrapFactor = runtimeLibs:
    runCommand (lib.appendToName "with-libs" interpreter).name
      {
        nativeBuildInputs = [ makeWrapper ];
        buildInputs = [ gdk-pixbuf ];
        passthru.runtimeLibs = runtimeLibs ++ interpreter.runtimeLibs;
      }
      (wrapFactorScript {
        from = "${interpreter}/lib/factor/.factor-wrapped";
        to = "$out/bin/factor";
        runtimeLibs = (runtimeLibs ++ interpreter.runtimeLibs);
      });

  # Development helper for use in nix shell
  wrapLocalFactor = writeScriptBin "wrapFactor" ''
    #!${runtimeShell}
    ${wrapFactorScript { from = "./factor"; inherit runtimeLibs; }}
    ln -sf factor.image .factor-wrapped.image
  '';
  rev = "e10b64dbc53a8583098e73580a1eb9ff4ce0c709";
  version = "0.99";

in
stdenv.mkDerivation {
  pname = "factor-lang";
  inherit version;

  src = fetchurl {
    url = "https://downloads.factorcode.org/releases/${version}/factor-src-${version}.zip";
    sha256 = "f5626bb3119bd77de9ac3392fdbe188bffc26557fab3ea34f7ca21e372a8443e";
  };

  patches = [
    ./staging-command-line-0.99-pre.patch
    ./workdir-0.99-pre.patch
    ./adjust-paths-in-unit-tests.patch
  ];

  nativeBuildInputs = [ git makeWrapper curl unzip wrapLocalFactor ];
  buildInputs = runtimeLibs;

  postPatch = ''
    sed -ie '4i GIT_LABEL = heads/master-${rev}' GNUmakefile

    # There is no ld.so.cache in NixOS so we patch out calls to that completely.
    # This should work as long as no application code relies on `find-library*`
    # to return a match, which currently is the case and also a justified assumption.

    sed -ie "s#/sbin/ldconfig -p#cat $out/lib/factor/ld.so.cache#g" \
      basis/alien/libraries/finder/linux/linux.factor

    # Some other hard-coded paths to fix:
    sed -i 's#/usr/share/zoneinfo/#${tzdata}/share/zoneinfo/#g' \
      extra/tzinfo/tzinfo.factor

    sed -i 's#/usr/share/terminfo#${ncurses.out}/share/terminfo#g' \
      extra/terminfo/terminfo.factor

    # De-memoize xdg-* functions, otherwise they break the image.
    sed -ie 's/^MEMO:/:/' basis/xdg/xdg.factor

    # update default paths in factor-listener.el for fuel mode
    substituteInPlace misc/fuel/fuel-listener.el \
      --replace '(defcustom fuel-factor-root-dir nil' "(defcustom fuel-factor-root-dir \"$out/lib/factor\""
  '';

  buildPhase = ''
    runHook preBuild
    # Necessary here, because ld.so.cache is needed in its final location during rebuild.
    mkdir -p $out/bin $out/lib/factor
    patchShebangs ./build.sh
    # Factor uses XDG_CACHE_HOME for cache during compilation.
    # We can't have that. So, set it to $TMPDIR/.cache
    export XDG_CACHE_HOME=$TMPDIR/.cache && mkdir -p $XDG_CACHE_HOME

    # There is no ld.so.cache in NixOS so we construct one
    # out of known libraries. The side effect is that find-lib
    # will work only on the known libraries. There does not seem
    # to be a generic solution here.
    find $(echo ${lib.makeLibraryPath runtimeLibs} | sed -e 's#:# #g') -name \*.so.\* > $TMPDIR/so.lst
    (echo $(cat $TMPDIR/so.lst | wc -l) "libs found in cache \`/etc/ld.so.cache'";
      for l in $(<$TMPDIR/so.lst); do
        echo " $(basename $l) (libc6,x86-64) => $l";
      done)> $out/lib/factor/ld.so.cache

    make -j$NIX_BUILD_CORES linux-x86-64
    printf "First build from upstream boot image\n" >&2
    ./build.sh bootstrap
    printf "Rebuild boot image\n" >&2
    ./factor -script -e='"unix-x86.64" USING: system bootstrap.image memory ; make-image save 0 exit'
    printf "Second build from local boot image\n" >&2
    ./build.sh bootstrap
    runHook postBuild
  '';

  # For now, the check phase runs, but should always return 0. This way the logs
  # contain the test failures until all unit tests are fixed. Then, it should
  # return 1 if any test failures have occured.
  doCheck = false;
  checkPhase = ''
    runHook preCheck
    set +e
    ./factor -e='USING: tools.test zealot.factor sequences namespaces formatting ;
      zealot-core-vocabs "compiler" suffix [ test ] each :test-failures
      test-failures get length "Number of failed Tests: %d\n" printf'
    [ $? -eq 0 ] || {
      mkdir -p "$out/nix-support"
      touch "$out/nix-support/failed"
    }
    set -e
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    cp -r factor factor.image LICENSE.txt README.md basis core extra misc $out/lib/factor

    # Create a wrapper in bin/ and lib/factor/
    ${wrapFactorScript { from = "$out/lib/factor/factor"; inherit runtimeLibs; }}
    mv $out/lib/factor/factor.image $out/lib/factor/.factor-wrapped.image
    cp $out/lib/factor/factor $out/bin/

    # Emacs fuel expects the image being named `factor.image` in the factor base dir
    ln -s $out/lib/factor/.factor-wrapped.image $out/lib/factor/factor.image

    # install fuel mode for emacs
    mkdir -p $out/share/emacs/site-lisp
    ln -s $out/lib/factor/misc/fuel/*.el $out/share/emacs/site-lisp/
    runHook postInstall
  '';

  passthru = {
    inherit runtimeLibs wrapFactorScript;
    withLibs = wrapFactor;
  };

  meta = with lib; {
    homepage = "https://factorcode.org/";
    description = "Concatenative, stack-based programming language";
    longDescription = ''
      The Factor programming language is a concatenative, stack-based
      programming language with high-level features including dynamic types,
      extensible syntax, macros, and garbage collection. On a practical side,
      Factor has a full-featured library, supports many different platforms, and
      has been extensively documented.

      The implementation is fully compiled for performance, while still
      supporting interactive development. Factor applications are portable
      between all common platforms. Factor can deploy stand-alone applications
      on all platforms. Full source code for the Factor project is available
      under a BSD license.
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra spacefrogg ];
    platforms = lib.intersectLists platforms.x86_64 platforms.linux;
    mainProgram = "factor";
  };
}
