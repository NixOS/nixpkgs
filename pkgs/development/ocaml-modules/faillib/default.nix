{stdenv, buildOcaml, fetchurl, herelib, camlp4}:

buildOcaml rec {
  minimumSupportedOcamlVersion = "4.00";
  name = "faillib";
  version = "111.17.00";

  src = fetchurl {
    url = "https://github.com/janestreet/faillib/archive/${version}.tar.gz";
    sha256 = "12dvaxkmgf7yzzvbadcyk1n17llgh6p8qr33867d21npaljy7l9v"; 
  };

  propagatedBuildInputs = [ camlp4 herelib ];

  doCheck = true;
  checkPhase = "make test";

  meta = with stdenv.lib; {
    homepage = https://ocaml.janestreet.com/;
    description = "Library for dealing with failure in OCaml";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer ];
  };
}
