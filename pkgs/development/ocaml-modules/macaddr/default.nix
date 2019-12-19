{ stdenv, fetchFromGitHub, buildDunePackage, ocaml
, ppx_sexp_conv, sexplib
}:

buildDunePackage rec {
  pname = "macaddr";
  version = "3.1.0";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-ipaddr";
    rev = "v${version}";
    sha256 = "0g7wgfn06z7fhdk4hlblf7b5k2ws56z0l73gk7189p5wvrmbavvx";
  };

  buildInputs = [ sexplib ];

  propagatedBuildInputs = [ ppx_sexp_conv ];

  doCheck = false; # ipaddr and macaddr tests are together, which requires mutual dependency

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-ipaddr;
    description = "A library for manipulation of MAC address representations";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
