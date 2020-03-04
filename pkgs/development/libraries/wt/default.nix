{ stdenv, fetchFromGitHub, cmake, boost, pkgconfig, doxygen, qt48Full, libharu
, pango, fcgi, firebird, libmysqlclient, postgresql, graphicsmagick, glew, openssl
, pcre, harfbuzz
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

      enableParallelBuilding = true;

      nativeBuildInputs = [ pkgconfig ];
      buildInputs = [
        cmake boost doxygen qt48Full libharu
        pango fcgi firebird libmysqlclient postgresql graphicsmagick glew
        openssl pcre
      ];

      cmakeFlags = [
        "-DWT_CPP_11_MODE=-std=c++11"
        "--no-warn-unused-cli"
      ]
      ++ stdenv.lib.optionals (graphicsmagick != null) [
        "-DWT_WRASTERIMAGE_IMPLEMENTATION=GraphicsMagick"
        "-DGM_PREFIX=${graphicsmagick}"
      ]
      ++ stdenv.lib.optional (harfbuzz != null)
        "-DHARFBUZZ_INCLUDE_DIR=${harfbuzz.dev}/include"
      ++ stdenv.lib.optional (libmysqlclient != null)
        "-DMYSQL_PREFIX=${libmysqlclient}";

      meta = with stdenv.lib; {
        homepage = "https://www.webtoolkit.eu/wt";
        description = "C++ library for developing web applications";
        platforms = platforms.linux;
        license = licenses.gpl2;
        maintainers = with maintainers; [ juliendehos willibutz ];
      };
    };
in {
  wt3 = generic {
    version = "3.5.0";
    sha256 = "1xcwzldbval5zrf7f3n2gkpscagg51cw2jp6p3q1yh6bi59haida";
  };

  wt4 = generic {
    version = "4.2.0";
    sha256 = "0zrrdjz0sa8hrmybjp4aap1lcqcqvsicd7dj49zj1m5k8gnfpm4v";
  };
}
