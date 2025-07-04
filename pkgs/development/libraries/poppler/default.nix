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
  pdfslicer,
  scribus,
  vips,
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
    rev = "91ee031c882634c36f2f0f2f14eb6646dd542fb9";
    hash = "sha256-bImTdlhMAA79kwbKPrHN3a9vVrtsgBh3rFjH3B7tEbQ=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "poppler-${suffix}";
  version = "25.05.0"; # beware: updates often break cups-filters build, check scribus too!

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://poppler.freedesktop.org/poppler-${finalAttrs.version}.tar.xz";
    hash = "sha256-mxYnxbdoFqxeQFKgP1tgW6QLRc8GsCyt0EeWILSZqzg=";
  };

  nativeBuildInputs =
    [
      cmake
      ninja
      pkg-config
      python3
    ]
    ++ lib.optionals (!minimal) [
      glib # for glib-mkenums
    ];

  buildInputs =
    [
      boost
      libiconv
      libintl
    ]
    ++ lib.optionals withData [
      poppler_data
    ];

  # TODO: reduce propagation to necessary libs
  propagatedBuildInputs =
    [
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

  cmakeFlags =
    [
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
    ]
    ++ lib.optionals finalAttrs.finalPackage.doCheck [
      "-DTESTDATADIR=${testData}"
    ];
  disallowedReferences = lib.optional finalAttrs.finalPackage.doCheck testData;

  dontWrapQtApps = true;

  # Workaround #54606
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
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
        pdfslicer
        vips
        ;
      gdal = gdal.override { usePoppler = true; };
      python-poppler-qt5 = python3.pkgs.poppler-qt5;
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
    maintainers = with lib.maintainers; [ ttuegel ];
    teams = [ lib.teams.freedesktop ];
  };
})
