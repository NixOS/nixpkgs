{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitLab,
  cairo,
  cmake,
  boost,
  curl,
  fontconfig,
  freetype,
  glib,
  lcms,
  libiconv,
  libintl,
  libjpeg,
  libtiff,
  ninja,
  openjpeg,
  pkg-config,
  python3,
  zlib,
  withData ? true,
  poppler_data,
  qt5Support ? false,
  qt6Support ? false,
  qtbase ? null,
  introspectionSupport ? false,
  gobject-introspection ? null,
  gpgmeSupport ? false,
  gpgme ? null,
  utils ? false,
  nss ? null,
  minimal ? false,
  suffix ? "glib",

  # for passthru.tests
  cups-filters,
  gdal,
  gegl,
  inkscape,
  scribus,
  vips,
  testers,
}:

let
  mkFlag = optset: flag: "-DENABLE_${flag}=${if optset then "on" else "off"}";

  # unclear relationship between test data repo versions and poppler
  # versions, though files don't appear to be updated after they're
  # added, so it's probably safe to just always use the latest available
  # version.
  testData = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "poppler";
    repo = "test";
    rev = "f0068e9c530017ad811d1f28b95f9b7f59264e37";
    hash = "sha256-Xf8duSh0r1o09b5BKB7mBvzrMfXYlzTuTOuK2ZCeItc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "poppler-${suffix}";
  version = "26.06.0"; # beware: updates often break cups-filters build, check scribus too!

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://poppler.freedesktop.org/poppler-${finalAttrs.version}.tar.xz";
    hash = "sha256-TLTlo9yMte7HUciiPIuhn2H5be3AzQfSruawyOLPa6Q=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
  ]
  ++ lib.optionals (!minimal) [
    glib # for glib-mkenums
  ];

  buildInputs = [
    boost
    libiconv
    libintl
  ]
  ++ lib.optionals withData [
    poppler_data
  ];

  # TODO: reduce propagation to necessary libs
  propagatedBuildInputs = [
    zlib
    freetype
    fontconfig
    libjpeg
    openjpeg
  ]
  ++ lib.optionals (!minimal) [
    cairo
    lcms
    libtiff
    curl
    nss
  ]
  ++ lib.optionals (qt5Support || qt6Support) [
    qtbase
  ]
  ++ lib.optionals introspectionSupport [
    gobject-introspection
  ]
  ++ lib.optionals gpgmeSupport [
    gpgme
  ];

  cmakeFlags = [
    (mkFlag true "UNSTABLE_API_ABI_HEADERS") # previously "XPDF_HEADERS"
    (mkFlag (!minimal) "GLIB")
    (mkFlag (!minimal) "CPP")
    (mkFlag (!minimal) "LIBCURL")
    (mkFlag (!minimal) "LCMS")
    (mkFlag (!minimal) "LIBTIFF")
    (mkFlag (!minimal) "NSS3")
    (mkFlag utils "UTILS")
    (mkFlag qt5Support "QT5")
    (mkFlag qt6Support "QT6")
    (mkFlag gpgmeSupport "GPGME")
  ];
  disallowedReferences = lib.optional finalAttrs.finalPackage.doCheck testData;

  dontWrapQtApps = true;

  preConfigure =
    lib.optionalString finalAttrs.finalPackage.doCheck ''
      # The test data directory needs to be writable during the test phase.
      mkdir -p $TMPDIR/testdata
      cp -r --no-preserve=mode ${testData}/* $TMPDIR/testdata
      cmakeFlagsArray+=(-DTESTDATADIR=$TMPDIR/testdata)
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Workaround #54606
      sed -i -e '1i cmake_policy(SET CMP0025 NEW)' CMakeLists.txt
    '';

  # Work around gpgme trying to write to $HOME during qt5 and qt6 tests:
  preCheck = lib.optionalString gpgmeSupport ''
    HOME_orig="$HOME"
    export HOME="$(mktemp -d)"
  '';

  postCheck = lib.optionalString gpgmeSupport ''
    export HOME="$HOME_orig"
    unset -v HOME_orig
  '';

  doCheck = true;

  passthru = {
    inherit testData;
    tests = {
      # These depend on internal poppler code that frequently changes.
      inherit
        cups-filters
        inkscape
        scribus
        ;

      inherit
        gegl
        vips
        ;
      gdal = gdal.override { usePoppler = true; };
      python-poppler-qt5 = python3.pkgs.poppler-qt5;

      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    homepage = "https://poppler.freedesktop.org/";
    changelog = "https://gitlab.freedesktop.org/poppler/poppler/-/blob/poppler-${finalAttrs.version}/NEWS";
    description = "PDF rendering library";
    longDescription = ''
      Poppler is a PDF rendering library based on the xpdf-3.0 code base. In
      addition it provides a number of tools that can be installed separately.
    '';
    license = with lib.licenses; [ gpl2Plus ];
    platforms = lib.platforms.all;
    maintainers = [ ];
    teams = [ lib.teams.freedesktop ];
    pkgConfigModules = [
      "poppler"
    ]
    ++ lib.optionals (!minimal) [ "poppler-cpp" ]
    ++ lib.optionals introspectionSupport [ "poppler-glib" ];
  };
})
