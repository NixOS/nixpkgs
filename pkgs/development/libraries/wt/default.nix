{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  pkg-config,
  doxygen,
  qt5,
  libharu,
  pango,
  fcgi,
  firebird,
  libmysqlclient,
  libpq,
  graphicsmagick,
  glew,
  openssl,
  harfbuzz,
  icu,
  libice,
  libsm,
}:

let
  generic =
    { version, hash }:
    stdenv.mkDerivation {
      pname = "wt";
      inherit version;

      src = fetchFromGitHub {
        owner = "emweb";
        repo = "wt";
        tag = version;
        inherit hash;
      };

      nativeBuildInputs = [
        cmake
        pkg-config
      ];
      buildInputs = [
        boost
        doxygen
        qt5.qtbase
        libharu
        pango
        fcgi
        firebird
        libmysqlclient
        libpq
        graphicsmagick
        glew
        openssl
        harfbuzz
        icu
        libice
        libsm
      ];

      dontWrapQtApps = true;
      cmakeFlags = [
        "-DCMAKE_INSTALL_RPATH=${
          lib.makeLibraryPath [
            libice
            libsm
          ]
        }"
        "-DWT_CPP_11_MODE=-std=c++11"
        "--no-warn-unused-cli"
      ]
      ++ lib.optionals (graphicsmagick != null) [
        "-DWT_WRASTERIMAGE_IMPLEMENTATION=GraphicsMagick"
        "-DGM_PREFIX=${graphicsmagick}"
      ]
      ++ lib.optional (libmysqlclient != null) "-DMYSQL_PREFIX=${libmysqlclient}";

      meta = {
        homepage = "https://www.webtoolkit.eu/wt";
        description = "C++ library for developing web applications";
        platforms = lib.platforms.linux;
        license = lib.licenses.gpl2Only;
        maintainers = with lib.maintainers; [ juliendehos ];
      };
    };
in
{
  wt4 = generic {
    version = "4.14.1";
    hash = "sha256-9ABX6ZyZmiTjWskre4slbSVa/OHyvoLGANHtM04LBmY=";
  };
}
