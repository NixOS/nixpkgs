{stdenv, fetchurl, ocaml, findlib, easy-format}:
let
  pname = "biniou";
  version = "1.0.9";
  webpage = "http://mjambon.com/${pname}.html";
in
stdenv.mkDerivation rec {

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://mjambon.com/releases/${pname}/${name}.tar.gz";
    sha256 = "14j3hrhbjqxbizr1pr8fcig9dmfzhbjjwzwyc99fcsdic67w8izb";
  };

  buildInputs = [ ocaml findlib easy-format ];

  createFindlibDestdir = true;

  makeFlags = "PREFIX=$(out)";

  preBuild = ''
    mkdir $out/bin
  '';

  meta = {
    description = "A binary data format designed for speed, safety, ease of use and backward compatibility as protocols evolve";
    homepage = "${webpage}";
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms;
  };
}
