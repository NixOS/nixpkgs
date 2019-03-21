{stdenv, fetchurl, omake, ocaml, libtiff, libjpeg, libpng, giflib, findlib, libXpm, freetype, graphicsmagick, ghostscript }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.00";

if stdenv.lib.versionAtLeast ocaml.version "4.06"
then throw "camlimages-4.1.2 is not available for OCaml ${ocaml.version}"
else

let
  pname = "camlimages";
  version = "4.1.2";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/camlspotter/camlimages/get/${version}.tar.bz2";
    sha256 = "1ppddhfknpirj1vilm5dxgyp82kf7ahpvjmh7z75a1fnaqv3kpki";
  };

  buildInputs = [ ocaml omake findlib graphicsmagick ghostscript ];

  propagatedBuildInputs = [libtiff libjpeg libpng giflib freetype libXpm ];

  createFindlibDestdir = true;

  buildPhase = ''
    omake
  '';

  installPhase = ''
    omake install
  '';

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/camlspotter/camlimages;
    description = "OCaml image processing library";
    license = licenses.lgpl2;
    maintainers = [ maintainers.vbgl ];
  };
}
