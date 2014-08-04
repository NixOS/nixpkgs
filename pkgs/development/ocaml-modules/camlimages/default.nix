{stdenv, fetchurl, omake, ocaml, omake_rc1, libtiff, libjpeg, libpng, giflib, findlib, libXpm, freetype, graphicsmagick, ghostscript }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "camlimages";
  version = "4.0.1";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/camlspotter/camlimages/get/v4.0.1.tar.gz";
    sha256 = "b40237c1505487049799a7af296eb3996b3fa08eab94415546f46d61355747c4";
  };

  buildInputs = [ocaml omake_rc1 findlib graphicsmagick ghostscript libtiff libjpeg libpng giflib freetype libXpm ];

  propagatedbuildInputs = [libtiff libjpeg libpng giflib freetype libXpm ];

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

  #makeFlags = "BINDIR=$(out)/bin  MANDIR=$(out)/usr/share/man/man1 DYPGENLIBDIR=$(out)/lib/ocaml/${ocaml_version}/site-lib";

  meta = {
    homepage = http://cristal.inria.fr/camlimages;
    description = "Image manipulation library";
    license = stdenv.lib.licenses.gpl2;
#    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
