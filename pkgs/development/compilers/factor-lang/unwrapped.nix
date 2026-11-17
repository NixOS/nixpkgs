{
  lib,
  stdenv,
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

let
  inherit (lib) optionalString versionOlder;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "factor-lang";

  inherit src version;
  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    # Use full path to image while bootstrapping
    ./staging-command-line-0.99-pre.patch
    # Point work vocabulary root to a writable location
    ./workdir-0.99-pre.patch
  ]
  ++ (
    if (versionOlder finalAttrs.version "0.102") then
      [
        # Patch hard-coded FHS paths
        ./adjust-paths-in-unit-tests.patch
        # Avoid using /sbin/ldconfig
        ./ld.so.cache-from-env.patch
      ]
    else
      [
        # Patch hard-coded FHS paths
        ./adjust-paths-in-unit-tests-0.102.patch
        # Avoid using /sbin/ldconfig
        ./ld.so.cache-from-env-0.102.patch
      ]
  );

  nativeBuildInputs = [
    git
    makeWrapper
    curl
    unzip
  ];

  postPatch = ''
    sed -i -e '/GIT_LABEL :=/c GIT_LABEL := heads/master-'$(< git-id) GNUmakefile
    # Some other hard-coded paths to fix:
    substituteInPlace extra/tzinfo/tzinfo.factor \
      --replace-fail '/usr/share/zoneinfo' '${tzdata}/share/zoneinfo'

    substituteInPlace extra/terminfo/terminfo.factor \
      --replace-fail '/usr/share/terminfo' '${ncurses.out}/share/terminfo'
  ''
  + optionalString (versionOlder finalAttrs.version "0.101") ''
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

  archParameters =
    with stdenv.hostPlatform;
    let
      os =
        if isDarwin then
          "macos"
        else if isWindows then
          "windows"
        else if isFreeBSD then
          "freebsd"
        else
          "linux";
      unixOrWin = if isWindows then "windows" else "unix";
      arch =
        if isAarch64 then
          {
            a = "arm";
            b = "64";
          }
        else if isRiscV then
          {
            a = "riscv";
            b = if isRiscV32 then "32" else "64";
          }
        else if isx86 then
          {
            a = "x86";
            b = if isx86_32 then "32" else "64";
          }
        else
          throw "Unsupported platform architecture";
    in
    {
      bootImage = "${unixOrWin}-${arch.a}.${arch.b}";
      makeTarget = "${os}-${arch.a}-${arch.b}";
      binaries =
        if isDarwin then
          [
            "factor"
            "Factor.app"
            "libfactor.dylib"
            "libfactor-ffi-test.dylib"
          ]
        else if isUnix then
          [
            "factor"
            "libfactor.a"
            "libfactor-ffi-test.so"
          ]
        else if isWindows then
          [ "factor.exe" ]
        else
          throw "Unsupported platform architecture";
    };

  makeTarget = finalAttrs.archParameters.makeTarget;

  postBuild = ''
    printf "First build from upstream boot image\n" >&2
    ./build.sh bootstrap
    printf "Rebuild boot image\n" >&2
    ./factor -script -e='"${finalAttrs.archParameters.bootImage}" USING: system bootstrap.image memory ; make-image save 0 exit'
    printf "Second build from local boot image\n" >&2
    ./build.sh bootstrap
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/factor
    cp -r factor.image ${lib.concatStringsSep " " finalAttrs.archParameters.binaries} \
        boot.${finalAttrs.archParameters.bootImage}.image LICENSE.txt README.md basis core extra misc \
        $out/lib/factor
  ''
  + optionalString (versionOlder finalAttrs.version "0.101") ''
    # install fuel mode for emacs
    mkdir -p $out/share/emacs/site-lisp
    ln -r -s $out/lib/factor/misc/fuel/*.el $out/share/emacs/site-lisp
    runHook postInstall
  '';

  meta = {
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
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      spacefrogg
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
})
