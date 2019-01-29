{ stdenv, fetchFromGitHub, cmake, boost, pkgconfig, doxygen, qt48Full, libharu
, pango, fcgi, firebird, mysql, postgresql, graphicsmagick, glew, openssl
, pcre
}:

let
  generic =
    { version, sha256 }:
    stdenv.mkDerivation rec {
      name = "wt-${version}";

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
        pango fcgi firebird mysql.connector-c postgresql graphicsmagick glew
        openssl pcre
      ];

      cmakeFlags = [
        "-DWT_WRASTERIMAGE_IMPLEMENTATION=GraphicsMagick"
        "-DWT_CPP_11_MODE=-std=c++11"
        "-DGM_PREFIX=${graphicsmagick}"
        "-DMYSQL_PREFIX=${mysql.connector-c}"
        "--no-warn-unused-cli"
      ];

      meta = with stdenv.lib; {
        homepage = https://www.webtoolkit.eu/wt;
        description = "C++ library for developing web applications";
        platforms = platforms.linux;
        license = licenses.gpl2;
        maintainers = with maintainers; [ juliendehos willibutz ];
      };
    };
in {
  wt3 = generic {
    version = "3.3.11";
    sha256 = "1s1bwg3s7brnspr9ya1vg5mr29dbvhf05s606fiv409b7ladqvxq";
  };

  wt4 = generic {
    version = "4.0.5";
    sha256 = "1gn8f30mjmn9aaxdazk49wijz37nglfww15ydrjiyhl6v5xhsjdv";
  };
}
