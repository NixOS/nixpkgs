{ stdenv, fetchFromGitHub, cmake, boost, pkgconfig, doxygen, qt48Full, libharu
, pango, fcgi, firebird, mysql, postgresql, graphicsmagick, glew, openssl
, pcre
}:

let
  generic =
    { version, sha256 }:
    stdenv.mkDerivation rec {
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
        homepage = "https://www.webtoolkit.eu/wt";
        description = "C++ library for developing web applications";
        platforms = platforms.linux;
        license = licenses.gpl2;
        maintainers = with maintainers; [ juliendehos willibutz ];
      };
    };
in {
  wt3 = generic {
    version = "3.4.0";
    sha256 = "0y0b2h9jf5cg1gdh48dj32pj5nsvipab1cgygncxf98c46ikhysg";
  };

  wt4 = generic {
    version = "4.1.0";
    sha256 = "1a9nl5gs8m8pssf2l3z6kbl2rc9fw5ad7lfslw5yr3gzi0zqn05x";
  };
}
