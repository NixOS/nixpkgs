{ stdenv, fetchurl, omake, ocaml, libtiff, libjpeg, libpng, giflib, findlib, libXpm, freetype, graphicsmagick, ghostscript }:

let
  pname = "camlimages";
  version = "4.0.1";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/camlspotter/camlimages/get/v4.0.1.tar.gz";
    sha256 = "b40237c1505487049799a7af296eb3996b3fa08eab94415546f46d61355747c4";
  };

  buildInputs = [ ocaml omake findlib graphicsmagick ghostscript ];

  propagatedBuildInputs = [libtiff libjpeg libpng giflib freetype libXpm ];

  createFindlibDestdir = true;

  preConfigure = ''
    rm ./configure
  '';

  buildPhase = ''
    omake
  '';

  installPhase = ''
    omake install
  '';

  meta = with stdenv.lib; {
    branch = "4.0";
    homepage = "https://bitbucket.org/camlspotter/camlimages";
    description = "OCaml image processing library";
    license = licenses.lgpl2;
    maintainers = [ maintainers.vbgl ];
  };
}
