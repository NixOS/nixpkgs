{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  pkg-config,
  doxygen,
  qtbase,
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
}:

let
  generic =
    { version, sha256 }:
    stdenv.mkDerivation {
      pname = "wt";
      inherit version;

      src = fetchFromGitHub {
        owner = "emweb";
        repo = "wt";
        rev = version;
        inherit sha256;
      };

      nativeBuildInputs = [
        cmake
        pkg-config
      ];
      buildInputs = [
        boost
        doxygen
        qtbase
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
      ];

      dontWrapQtApps = true;
      cmakeFlags = [
        "-DWT_CPP_11_MODE=-std=c++11"
        "--no-warn-unused-cli"
      ]
      ++ lib.optionals (graphicsmagick != null) [
        "-DWT_WRASTERIMAGE_IMPLEMENTATION=GraphicsMagick"
        "-DGM_PREFIX=${graphicsmagick}"
      ]
      ++ lib.optional (libmysqlclient != null) "-DMYSQL_PREFIX=${libmysqlclient}";

      meta = with lib; {
        homepage = "https://www.webtoolkit.eu/wt";
        description = "C++ library for developing web applications";
        platforms = platforms.linux;
        license = licenses.gpl2;
        maintainers = with maintainers; [ juliendehos ];
      };
    };
in
{
  wt4 = generic {
    version = "4.12.1";
    sha256 = "sha256-IewHB5F+9NdGYojHK68WQUE3WveX3k9UA4iVQ0z6JNk=";
  };
}
