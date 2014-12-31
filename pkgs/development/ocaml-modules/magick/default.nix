{ stdenv, fetchurl, which, pkgconfig, ocaml, findlib, imagemagick }:

stdenv.mkDerivation {
  name = "ocaml-magick-0.34";
  src = fetchurl {
    url = http://www.linux-nantes.org/~fmonnier/OCaml/ImageMagick/ImageMagick/OCaml-ImageMagick-0.34.tgz;
    sha256 = "0gn9l2qdr8gby2x8c2mb59x1kipb2plr45rbq6ymcxyi0wmzfh3q";
  };

  nativeBuildInputs = [ which pkgconfig ];
  buildInputs = [ ocaml findlib imagemagick ];

  createFindlibDestdir = true;

  installTargets = [ "find_install" ];

  meta = {
    homepage = http://www.linux-nantes.org/~fmonnier/OCaml/ImageMagick/;
    description = "ImageMagick Binding for OCaml";
    license = stdenv.lib.licenses.mit;
    platforms = imagemagick.meta.platforms;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
