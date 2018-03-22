{ stdenv, fetchFromGitHub, cmake, boost165, pkgconfig, doxygen, qt48Full, libharu
, pango, fcgi, firebird, mysql, postgresql, graphicsmagick, glew, openssl
, pcre
}:

let
  generic =
    { version, sha256 }:
    stdenv.mkDerivation rec {
      name = "wt-${version}";

      src = fetchFromGitHub {
        owner = "kdeforche";
        repo = "wt";
        rev = version;
        inherit sha256;
      };

      enableParallelBuilding = true;

      nativeBuildInputs = [ pkgconfig ];
      buildInputs = [
        cmake boost165 doxygen qt48Full libharu
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
    # with the next version update the version pinning of boost should be omitted
    version = "3.3.9";
    sha256 = "1mkflhvzzzxkc5yzvr6nk34j0ldpwxjxb6n7xml59h3j3px3ixjm";
  };

  wt4 = generic {
    # with the next version update the version pinning of boost should be omitted
    version = "4.0.2";
    sha256 = "0r729gjd1sy0pcmir2r7ga33mp5cr5b4gvf44852q65hw2577w1x";
  };
}
