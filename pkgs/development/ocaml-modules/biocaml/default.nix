{ stdenv, buildDunePackage, fetchFromGitHub, fetchpatch
, ounit, async, base64, camlzip, cfstream
, core, ppx_jane, ppx_sexp_conv, rresult, uri, xmlm }:

buildDunePackage rec {
  pname = "biocaml";
  version = "0.11.1";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "biocaml";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1il84vvypgkhdyc2j5fmgh14a58069s6ijbd5dvyl2i7jdxaazji";
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
