{
  lib,
  stdenv,
  callPackage,
  makeSetupHook,
  buildPackages,
  runCommand,
  bashNonInteractive,
  autoreconfHook,
  tzdata,
  zip,
  zlib,

  # Version specific stuff
  release,
  version,
  src,
  extraPatch ? "",
  patches ? [ ],
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tcl";
  inherit version src;

  outputs = [
    "out"
    "man"
  ];

  setOutputFlags = false;

  inherit patches;

  postPatch = ''
    substituteInPlace library/clock.tcl \
      --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo" \
      --replace-fail "/usr/share/lib/zoneinfo" "" \
      --replace-fail "/usr/lib/zoneinfo" "" \
      --replace-fail "/usr/local/etc/zoneinfo" ""
  ''
  # A shared Cygwin build tries to configure the windows build system
  # to separately build these DLLs so it can load them later. That's
  # not gonna work for us --- in Nixpkgs this would need to be a
  # separate derivation with a separate wrapped C compiler --- so
  # let's just drop this for now.
  #
  # Matching just the recursive `make` and not the whole `( cd ...; ... )`
  # around it: 8.6 writes that without inner spaces and 9.0 with, and the
  # part we care about is the same either way.
  + lib.optionalString stdenv.hostPlatform.isCygwin ''
    substituteInPlace unix/Makefile.in \
      --replace-fail "\''${MAKE} winextensions" true
  ''
  + extraPatch;

  # The default hook is the newest autoconf that works for every tree we
  # regenerate, 8.6's 2.59-era `configure.in` included.
  nativeBuildInputs = [
    autoreconfHook
  ]
  ++ lib.optionals (lib.versionAtLeast version "9.0") [
    # Only used to detect the presence of zlib. Could be replaced with a stub.
    zip
  ]
  # In the windows build, `install-msgs` (and `install-tzdata`, but
  # we don't do that) are done via TCL not via shell. This is for
  # the sake of the "build = host = windows" case; we are merely
  # doing build = unix, host = windows, where the old shell way would
  # have worked.
  ++ lib.optionals (stdenv.hostPlatform.isWindows && stdenv.buildPlatform != stdenv.hostPlatform) [
    buildPackages.tcl
  ];

  buildInputs = [
    bashNonInteractive
  ]
  ++ lib.optionals (lib.versionAtLeast version "9.0") [
    zlib
  ];

  strictDeps = true;

  # Windows has its own build system under `win`, autoconf like the one under
  # `unix` but with its own `Makefile.in` and a smaller set of options. Cygwin
  # is not Windows for this purpose: it is POSIX enough for the `unix` one.
  preAutoreconf = ''
    cd ${if stdenv.hostPlatform.isWindows then "win" else "unix"}
  '';

  # No `--install`: there is no automake here, and letting `autoreconf`
  # regenerate `aclocal.m4` would lose the `tcl.m4` the build depends on.
  autoreconfFlags = "--force --verbose";

  configureFlags = [
    # tcl_cv_sys_version is intended to be set to `$(uname -s)-$(uname -r)`.
    "tcl_cv_sys_version=${
      lib.concatStringsSep "-" [
        stdenv.hostPlatform.uname.system
        (lib.optionalString (stdenv.hostPlatform.uname.release != null) stdenv.hostPlatform.uname.release)
      ]
    }"
    # During cross compilation, the tcl build system assumes that libc
    # functions are broken if it cannot test if they are broken or not and
    # then causes a link error on static platforms due to symbol conflict.
    # These functions are *checks notes* strtoul and strstr. These are
    # never broken on modern platforms!
    "tcl_cv_strtod_unbroken=ok"
    "tcl_cv_strtoul_unbroken=ok"
    "tcl_cv_strstr_unbroken=ok"
    # Note: using $out instead of $man to prevent a runtime dependency on $man.
    "--mandir=${placeholder "out"}/share/man"
    # Don't install tzdata because NixOS already has a more up-to-date copy.
    "--with-tzdata=no"
  ]
  ++ lib.optionals (lib.versionOlder version "9.0") [
    # Enabled is the default pre-9.0, but we don't want to leave
    # anything to chance. 9.0 and later the option is gone and
    # threads are always enabled.
    "--enable-threads"
  ]
  ++ lib.optionals (lib.versionAtLeast version "9.0") [
    # By default, tcl libraries get zipped and embedded into libtcl*.so,
    # which gets `zipfs mount`ed at runtime. This is fragile (for example
    # stripping the .so removes the zip trailer), so we install them as
    # traditional files.
    # This might make tcl slower to start from slower storage on cold cache,
    # however according to my benchmarks on fast storage and warm cache
    # tcl built with --disable-zipfs actually starts in half the time.
    "--disable-zipfs"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isWindows) [
    # Does not exist in the `win` build system.
    "--enable-man-symlinks"
  ]
  ++ lib.optional stdenv.hostPlatform.is64bit "--enable-64bit";

  # https://core.tcl-lang.org/thread/tktview/30e201c7111a438e2fe6aadc9d733b954874cbb9
  env = lib.optionalAttrs (lib.versionAtLeast version "9.0") { ZIPFS_BUILD = 0; };

  buildFlags = lib.optionals stdenv.hostPlatform.isStatic [
    # Don't use the default Make target for static,
    # since it builds shared libraries for bundled packages.
    "binaries"
    "libraries"
    "doc"
  ];

  makeFlags = lib.optionals stdenv.hostPlatform.isStatic [
    "INSTALL_PACKAGE_TARGETS="
  ];

  enableParallelBuilding = true;

  allowedImpureDLLs = lib.optionals stdenv.hostPlatform.isCygwin [ "USER32.dll" ];

  postInstall =
    let
      exeExtension = stdenv.hostPlatform.extensions.executable;
      dllExtension = stdenv.hostPlatform.extensions.sharedLibrary;
      staticExtension = stdenv.hostPlatform.extensions.staticLibrary;
      # The `win` build system drops the dot from the version when naming
      # files, so `tclsh86.exe` rather than `tclsh8.6`.
      infix =
        if stdenv.hostPlatform.isWindows then lib.replaceStrings [ "." ] [ "" ] release else release;
      # On PE platforms --- Mingw and Cygwin alike --- the DLL lives in
      # `bin` and the thing one links against is the import library in
      # `lib`, so that is what the unversioned name should point at.
      #
      # The import library is always `lib`-prefixed, even where the DLL
      # is not: Tcl 9 names its Cygwin DLL the way that platform does,
      # `cygtcl9.0.dll`, and 9.0's Cygwin `SHLIB_LD` in `unix/tcl.m4`
      # rewrites `cyg%.dll` to `lib%.dll.a` for the import library.
      linkExtension =
        if stdenv.hostPlatform.isWindows || stdenv.hostPlatform.isCygwin then
          "${dllExtension}.a"
        else
          dllExtension;
    in
    ''
      make install-private-headers
      ln -s $out/bin/tclsh${infix}${exeExtension} $out/bin/tclsh${exeExtension}
      if [[ -e $out/lib/libtcl${infix}${staticExtension} ]]; then
        ln -s $out/lib/libtcl${infix}${staticExtension} $out/lib/libtcl${staticExtension}
      fi
    ''
    + lib.optionalString (!stdenv.hostPlatform.isStatic) ''
      ln -s $out/lib/libtcl${infix}${linkExtension} $out/lib/libtcl${linkExtension}
    '';

  __structuredAttrs = true;

  meta = {
    description = "Tcl scripting language";
    homepage = "https://www.tcl.tk/";
    license = lib.licenses.tcltk;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ agbrooks ];
  };

  passthru =
    let
      libPrefix = "tcl${release}";
    in
    {
      inherit release version libPrefix;
      isTcl9 = lib.versions.major version == "9";
      libdir = "lib/${libPrefix}";
      tclPackageHook = callPackage (
        { buildPackages }:
        makeSetupHook {
          name = "tcl-package-hook";
          propagatedBuildInputs = [ buildPackages.makeBinaryWrapper ];
          meta = {
            inherit (finalAttrs.meta) maintainers platforms;
            license = lib.licenses.mit;
          };
        } ./tcl-package-hook.sh
      ) { };
      tclRequiresCheckHook = callPackage (
        { buildPackages }:
        makeSetupHook {
          name = "tcl-requires-check-hook";
          propagatedBuildInputs = [ buildPackages.makeBinaryWrapper ];
          meta = {
            inherit (finalAttrs.meta) maintainers platforms;
            license = lib.licenses.mit;
          };
        } ./tcl-requires-check-hook.sh
      ) { };
      # verify that Tcl's clock library can access tzdata
      tests.tzdata = runCommand "${finalAttrs.pname}-test-tzdata" { } ''
        ${finalAttrs.finalPackage}/bin/tclsh <(echo "set t [clock scan {2004-10-30 05:00:00} \
                                      -format {%Y-%m-%d %H:%M:%S} \
                                      -timezone :America/New_York]") > $out
      '';
      mkTclDerivation = callPackage ./mk-tcl-derivation.nix { tcl = finalAttrs.finalPackage; };
    };
})
