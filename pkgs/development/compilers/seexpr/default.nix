{ lib, stdenv, fetchFromGitHub, cmake, libpng, zlib, qt4,
bison, flex, libGLU, python2Packages
}:

stdenv.mkDerivation {
  pname = "seexpr";
  version = "2.11";
  src = fetchFromGitHub {
    owner  = "wdas";
    repo   = "SeExpr";
    rev    = "v2.11";
    sha256 = "0a44k56jf6dl36fwgg4zpc252wq5lf9cblg74mp73k82hxw439l4";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libGLU libpng zlib qt4 python2Packages.pyqt4 bison flex ];
  meta = with lib; {
    description = "Embeddable expression evaluation engine from Disney Animation";
    homepage = "https://www.disneyanimation.com/technology/seexpr.html";
    maintainers = with maintainers; [ hodapp ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
