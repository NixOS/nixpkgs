{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  curl,
  git,
  ncurses,
  tzdata,
  unzip,

  # Version-specific attributes
  version,
  src,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "factor-lang";

  inherit src version;

  patches = [
    # Use full path to image while bootstrapping
    ./staging-command-line-0.99-pre.patch
    # Point work vocabulary root to a writable location
    ./workdir-0.99-pre.patch
    # Patch hard-coded FHS paths
    ./adjust-paths-in-unit-tests.patch
    # Avoid using /sbin/ldconfig
    ./ld.so.cache-from-env.patch
  ];

  nativeBuildInputs = [
    git
    makeWrapper
    curl
    unzip
  ];

  postPatch = ''
    sed -ie '4i GIT_LABEL = heads/master-'$(< git-id) GNUmakefile
    # Some other hard-coded paths to fix:
    substituteInPlace extra/tzinfo/tzinfo.factor \
      --replace-fail '/usr/share/zoneinfo' '${tzdata}/share/zoneinfo'

    substituteInPlace extra/terminfo/terminfo.factor \
      --replace-fail '/usr/share/terminfo' '${ncurses.out}/share/terminfo'

    # update default paths in fuel-listener.el for fuel mode
    substituteInPlace misc/fuel/fuel-listener.el \
      --replace-fail '(defcustom fuel-factor-root-dir nil' "(defcustom fuel-factor-root-dir \"$out/lib/factor\""
  '';

  dontConfigure = true;

  preBuild = ''
    patchShebangs ./build.sh
    # Factor uses XDG_CACHE_HOME for cache during compilation.
    # We can't have that. So, set it to $TMPDIR/.cache
    export XDG_CACHE_HOME=$TMPDIR/.cache
    mkdir -p $XDG_CACHE_HOME
  '';

  makeTarget = "linux-x86-64";

  postBuild = ''
    printf "First build from upstream boot image\n" >&2
    ./build.sh bootstrap
    printf "Rebuild boot image\n" >&2
    ./factor -script -e='"unix-x86.64" USING: system bootstrap.image memory ; make-image save 0 exit'
    printf "Second build from local boot image\n" >&2
    ./build.sh bootstrap
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/factor $out/share/emacs/site-lisp
    cp -r factor factor.image libfactor.a libfactor-ffi-test.so \
        boot.*.image LICENSE.txt README.md basis core extra misc \
        $out/lib/factor

    # install fuel mode for emacs
    ln -r -s $out/lib/factor/misc/fuel/*.el $out/share/emacs/site-lisp
    runHook postInstall
  '';

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
    maintainers = with maintainers; [
      vrthra
      spacefrogg
    ];
    platforms = [ "x86_64-linux" ];
  };
})
