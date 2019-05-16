{ stdenv, fetchFromGitHub, cmake, libpng, zlib, qt4,
bison, flex, libGLU, pythonPackages
}:

stdenv.mkDerivation rec {
  name = "seexpr-${version}";
  version = "2.11";
  src = fetchFromGitHub {
    owner  = "wdas";
    repo   = "SeExpr";
    rev    = "v2.11";
    sha256 = "0a44k56jf6dl36fwgg4zpc252wq5lf9cblg74mp73k82hxw439l4";
  };

  buildInputs = [ cmake libGLU libpng zlib qt4 pythonPackages.pyqt4 bison flex ];
  meta = with stdenv.lib; {
    description = "Embeddable expression evaluation engine from Disney Animation";
    homepage = https://www.disneyanimation.com/technology/seexpr.html;
    maintainers = with maintainers; [ hodapp ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
