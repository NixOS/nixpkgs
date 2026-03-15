{
  lib,
  stdenv,
  autoreconfHook,
  callPackage,
  deterministic-host-uname,
  makeSetupHook,
  runCommand,
  tzdata,
  zip,
  zlib,

  # Version specific stuff
  release,
  version,
  src,
  patches ? [ ],
  extraPatch ? "",
  ...
}:

let
  baseInterp = stdenv.mkDerivation rec {
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
        --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo" \
        --replace "/usr/share/lib/zoneinfo" "" \
        --replace "/usr/lib/zoneinfo" "" \
        --replace "/usr/local/etc/zoneinfo" ""
    ''
    + extraPatch;

    nativeBuildInputs =
      lib.optionals (lib.versionAtLeast version "9.0") [
        # Only used to detect the presence of zlib. Could be replaced with a stub.
        zip
      ]
      ++ lib.optional (
        !lib.systems.equals stdenv.hostPlatform stdenv.buildPlatform
      ) deterministic-host-uname
      ++ lib.optional stdenv.hostPlatform.isCygwin autoreconfHook;

    buildInputs = lib.optionals (lib.versionAtLeast version "9.0") [
      zlib
    ];

    autoreconfFlags = if stdenv.hostPlatform.isCygwin then "unix" else null;

    preConfigure = ''
      cd unix
    '';

    # Note: pre-9.0 flags are temporarily interspersed to avoid a mass rebuild.
    configureFlags =
      lib.optionals (lib.versionOlder version "9.0") [
        "--enable-threads"
      ]
      ++ [
        # Note: using $out instead of $man to prevent a runtime dependency on $man.
        "--mandir=${placeholder "out"}/share/man"
      ]
      ++ lib.optionals (lib.versionOlder version "9.0") [
        "--enable-man-symlinks"
        # Don't install tzdata because NixOS already has a more up-to-date copy.
        "--with-tzdata=no"
      ]
      ++ lib.optionals (lib.versionOlder version "8.6") [
        # configure check broke due to GCC 14
        "ac_cv_header_stdc=yes"
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
      ++ [
        # During cross compilation, the tcl build system assumes that libc
        # functions are broken if it cannot test if they are broken or not and
        # then causes a link error on static platforms due to symbol conflict.
        # These functions are *checks notes* strtoul and strstr. These are
        # never broken on modern platforms!
        "tcl_cv_strtod_unbroken=ok"
        "tcl_cv_strtoul_unbroken=ok"
        "tcl_cv_strstr_unbroken=ok"
      ]
      ++ lib.optional stdenv.hostPlatform.is64bit "--enable-64bit";

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

    postInstall =
      let
        dllExtension = stdenv.hostPlatform.extensions.sharedLibrary;
        staticExtension = stdenv.hostPlatform.extensions.staticLibrary;
        exeExtension = stdenv.hostPlatform.extensions.executable;
        dllDir = if stdenv.hostPlatform.isCygwin then "bin" else "lib";
      in
      ''
        make install-private-headers
        ln -s $out/bin/tclsh${release}${exeExtension} $out/bin/tclsh${exeExtension}
        if [[ -e $out/lib/libtcl${release}${staticExtension} ]]; then
          ln -s $out/lib/libtcl${release}${staticExtension} $out/lib/libtcl${staticExtension}
        fi
        ${lib.optionalString (!stdenv.hostPlatform.isStatic) ''
          ln -s $out/${dllDir}/libtcl${release}${dllExtension} $out/${dllDir}/libtcl${dllExtension}
        ''}
      ''
      + lib.optionalString stdenv.hostPlatform.isCygwin ''
        ln -s $out/lib/libtcl${release}.dll${staticExtension} $out/lib/libtcl.dll${staticExtension}
      '';

    allowedImpureDLLs = [ "USER32.dll" ];

    meta = {
      description = "Tcl scripting language";
      homepage = "https://www.tcl.tk/";
      license = lib.licenses.tcltk;
      platforms = lib.platforms.all;
      maintainers = with lib.maintainers; [ agbrooks ];
    };

    passthru = rec {
      inherit release version;
      libPrefix = "tcl${release}";
      libdir = "lib/${libPrefix}";
      tclPackageHook = callPackage (
        { buildPackages }:
        makeSetupHook {
          name = "tcl-package-hook";
          propagatedBuildInputs = [ buildPackages.makeBinaryWrapper ];
          meta = {
            inherit (meta) maintainers platforms;
          };
        } ./tcl-package-hook.sh
      ) { };
      # verify that Tcl's clock library can access tzdata
      tests.tzdata = runCommand "${pname}-test-tzdata" { } ''
        ${baseInterp}/bin/tclsh <(echo "set t [clock scan {2004-10-30 05:00:00} \
                                      -format {%Y-%m-%d %H:%M:%S} \
                                      -timezone :America/New_York]") > $out
      '';
    };
  };

  mkTclDerivation = callPackage ./mk-tcl-derivation.nix { tcl = baseInterp; };

in
baseInterp.overrideAttrs (self: {
  passthru = self.passthru // {
    inherit mkTclDerivation;
  };
})
