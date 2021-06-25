{ lib, stdenv, fetchFromGitLab, fetchpatch, omake, ocaml, findlib
, graphicsmagick, ghostscript
, freetype, giflib, libjpeg, libpng, libtiff, libXpm
}:

stdenv.mkDerivation rec {
  pname = "camlimages";
  version = "4.1.2";

  src = fetchFromGitLab {
    owner = "camlspotter";
    repo = "camlimages";
    rev = "98661d507e12ce91a51295a50f244cb8265b4439"; # no tag
    sha256 = "0kpxj8wm2m17wjq217jzjpfgv1d7sp4w1yd1gi8ipn5rj4sid2j8";
  };

  buildInputs = [ ocaml omake findlib graphicsmagick ghostscript ];
  propagatedBuildInputs = [ libtiff libjpeg libpng giflib freetype libXpm ];

  createFindlibDestdir = true;

  buildPhase = ''
    omake
  '';

  installPhase = ''
    omake install
  '';

  meta = with lib; {
    branch = "4.1";
    homepage = "https://gitlab.com/camlspotter/camlimages";
    description = "OCaml image processing library";
    license = licenses.lgpl2;
    maintainers = [ maintainers.vbgl ];
  };
}
