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
        "-DHARFBUZZ_INCLUDE_DIR=${harfbuzz.dev}/include"
        "--no-warn-unused-cli"
      ]
      ++ stdenv.lib.optionals (graphicsmagick != null) [
        "-DWT_WRASTERIMAGE_IMPLEMENTATION=GraphicsMagick"
        "-DGM_PREFIX=${graphicsmagick}"
      ]
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
    version = "3.4.1";
    sha256 = "1bsx7hmy6g2x9p3vl5xw9lv1xk891pnvs93a87s15g257gznkjmj";
  };

  wt4 = generic {
    version = "4.1.1";
    sha256 = "1f1imx5kbpqlysrqx5h75hf2f8pkq972rz42x0pl6cxbnsyzngid";
  };
}
