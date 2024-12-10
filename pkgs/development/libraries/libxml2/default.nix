{
  stdenv,
  lib,
  fetchurl,
  zlib,
  pkg-config,
  autoreconfHook,
  xz,
  libintl,
  python,
  gettext,
  ncurses,
  findXMLCatalogs,
  libiconv,
  # Python limits cross-compilation to an allowlist of host OSes.
  # https://github.com/python/cpython/blob/dfad678d7024ab86d265d84ed45999e031a03691/configure.ac#L534-L562
  pythonSupport ?
    enableShared
    && (
      stdenv.hostPlatform == stdenv.buildPlatform
      || stdenv.hostPlatform.isCygwin
      || stdenv.hostPlatform.isLinux
      || stdenv.hostPlatform.isWasi
    ),
  icuSupport ? false,
  icu,
  enableShared ? !stdenv.hostPlatform.isMinGW && !stdenv.hostPlatform.isStatic,
  enableStatic ? !enableShared,
  gnome,
  testers,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "libxml2";
  version = "2.12.7";

  outputs =
    [
      "bin"
      "dev"
      "out"
      "doc"
    ]
    ++ lib.optional pythonSupport "py"
    ++ lib.optional (enableStatic && enableShared) "static";
  outputMan = "bin";

  src = fetchurl {
    url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor version}/libxml2-${version}.tar.xz";
    hash = "sha256-JK54/xNjqXPm2L66lBp5RdoqwFbhm1OVautpJ/1s+1Y=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs =
    lib.optionals pythonSupport [
      python
    ]
    ++ lib.optionals (pythonSupport && python ? isPy2 && python.isPy2) [
      gettext
    ]
    ++ lib.optionals (pythonSupport && python ? isPy3 && python.isPy3) [
      ncurses
    ]
    ++ lib.optionals (stdenv.isDarwin && pythonSupport && python ? isPy2 && python.isPy2) [
      libintl
    ]
    ++ lib.optionals stdenv.isFreeBSD [
      # Libxml2 has an optional dependency on liblzma.  However, on impure
      # platforms, it may end up using that from /usr/lib, and thus lack a
      # RUNPATH for that, leading to undefined references for its users.
      xz
    ];

  propagatedBuildInputs =
    [
      zlib
      findXMLCatalogs
    ]
    ++ lib.optionals stdenv.isDarwin [
      libiconv
    ]
    ++ lib.optionals icuSupport [
      icu
    ];

  configureFlags = [
    "--exec-prefix=${placeholder "dev"}"
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableShared "shared")
    (lib.withFeature icuSupport "icu")
    (lib.withFeature pythonSupport "python")
    (lib.optionalString pythonSupport "PYTHON=${python.pythonOnBuildForHost.interpreter}")
  ];

  installFlags = lib.optionals pythonSupport [
    "pythondir=\"${placeholder "py"}/${python.sitePackages}\""
    "pyexecdir=\"${placeholder "py"}/${python.sitePackages}\""
  ];

  enableParallelBuilding = true;

  doCheck = (stdenv.hostPlatform == stdenv.buildPlatform) && stdenv.hostPlatform.libc != "musl";
  preCheck = lib.optional stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="$PWD/.libs:$DYLD_LIBRARY_PATH"
  '';

  preConfigure = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  preInstall = lib.optionalString pythonSupport ''
    substituteInPlace python/libxml2mod.la --replace "$dev/${python.sitePackages}" "$py/${python.sitePackages}"
  '';

  postFixup =
    ''
      moveToOutput bin/xml2-config "$dev"
      moveToOutput lib/xml2Conf.sh "$dev"
    ''
    + lib.optionalString (enableStatic && enableShared) ''
      moveToOutput lib/libxml2.a "$static"
    '';

  passthru = {
    inherit version;
    pythonSupport = pythonSupport;

    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/libxml2";
    description = "XML parsing library for C";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [
      eelco
      jtojnar
    ];
    pkgConfigModules = [ "libxml-2.0" ];
  };
})
