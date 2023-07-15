{ lib, stdenv, fetchFromGitHub, cmake, boost, pkg-config, doxygen, qt48Full, libharu
, pango, fcgi, firebird, libmysqlclient, postgresql, graphicsmagick, glew, openssl
, pcre, harfbuzz, icu
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

      nativeBuildInputs = [ cmake pkg-config ];
      buildInputs = [
        boost doxygen qt48Full libharu
        pango fcgi firebird libmysqlclient postgresql graphicsmagick glew
        openssl pcre harfbuzz icu
      ];

      cmakeFlags = [
        "-DWT_CPP_11_MODE=-std=c++11"
        "--no-warn-unused-cli"
      ]
      ++ lib.optionals (graphicsmagick != null) [
        "-DWT_WRASTERIMAGE_IMPLEMENTATION=GraphicsMagick"
        "-DGM_PREFIX=${graphicsmagick}"
      ]
      ++ lib.optional (libmysqlclient != null)
        "-DMYSQL_PREFIX=${libmysqlclient}";

      meta = with lib; {
        homepage = "https://www.webtoolkit.eu/wt";
        description = "C++ library for developing web applications";
        platforms = platforms.linux;
        license = licenses.gpl2;
        maintainers = with maintainers; [ juliendehos willibutz ];
      };
    };
in {
  wt3 = generic {
    version = "3.7.1";
    sha256 = "19gf5lbrc5shpvcdyzjh20k8zdj4cybxqvkhwqfl9rvhw89qr11k";
  };

  wt4 = generic {
    version = "4.9.1";
    sha256 = "sha256-Qm0qqYB/CLVHUgKE9N83MgAWQ2YFdumrB0i84qYNto8=";
  };
}
