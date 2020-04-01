{ stdenv, buildDunePackage, fetchFromGitHub
, ounit, async, base64, camlzip, cfstream
, core, ppx_jane, ppx_sexp_conv, rresult, uri, xmlm }:

buildDunePackage rec {
  pname = "biocaml";
  version = "0.10.1";

  owner = "biocaml";

  minimumOCamlVersion = "4.07";

  src = fetchFromGitHub {
    inherit owner;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1f19nc8ld0iv45jjnsvaah3ddj88s2n9wj8mrz726kzg85cfr8xj";
  };

  buildInputs = [ ppx_jane ppx_sexp_conv ];
  checkInputs = [ ounit ];
  propagatedBuildInputs = [ async base64 camlzip cfstream core rresult uri xmlm ];

  meta = with stdenv.lib; {
    description = "Bioinformatics library for Ocaml";
    homepage = "http://${pname}.org";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.gpl2;
  };
}
