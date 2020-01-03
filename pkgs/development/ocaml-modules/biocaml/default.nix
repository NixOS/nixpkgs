{ stdenv, buildDunePackage, fetchFromGitHub
, ounit, async, base64, camlzip, cfstream
, core, ppx_jane, ppx_sexp_conv, rresult, uri, xmlm }:

buildDunePackage rec {
  pname = "biocaml";
  version = "0.10.0";

  owner = "biocaml";

  minimumOCamlVersion = "4.07";

  src = fetchFromGitHub {
    inherit owner;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0dghqx6jbzihmga8jjwwavs0wqksgcns4z1nmwj0ds9ik3mcra30";
  };

  buildInputs = [ ppx_jane ppx_sexp_conv ];
  checkInputs = [ ounit ];
  propagatedBuildInputs = [ async base64 camlzip cfstream core rresult uri xmlm ];

  meta = with stdenv.lib; {
    description = "Bioinformatics library for Ocaml";
    homepage = "http://${owner}.github.io/${pname}";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.gpl2;
  };
}
