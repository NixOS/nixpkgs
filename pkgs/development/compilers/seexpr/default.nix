{ mkDerivation, lib, stdenv, fetchFromGitHub, cmake, libpng, zlib,
bison, flex, libGLU, boost, python3
}:

mkDerivation rec {
  pname = "seexpr";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner  = "wdas";
    repo   = "SeExpr";
    rev    = "v${version}";
    sha256 = "0jdlaxkcm8s557vy17d6ykwcxa124qw2r84kc453w6y5pz4s1adg";
  };

  cmakeFlags = [
    "-DUSE_PYTHON=OFF" # doesn't work with either qt4 or qt5 at the moment
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libpng zlib boost bison flex ];

  meta = with lib; {
    description = "Embeddable expression evaluation engine from Disney Animation";
    homepage = "http://wdas.github.io/SeExpr/";
    maintainers = with maintainers; [ hodapp ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
