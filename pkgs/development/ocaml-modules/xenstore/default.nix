{ lib, buildDunePackage, fetchurl
, cstruct, ppx_cstruct, lwt, ounit2
}:

buildDunePackage rec {
  pname = "xenstore";
  version = "2.3.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-xenstore/releases/download/v${version}/xenstore-${version}.tbz";
    hash = "sha256-1jxrvLLTwpd2fYPAoPbdRs7P1OaR8c9cW2VURF7Bs/Q=";
  };

  buildInputs = [ ppx_cstruct ];
  propagatedBuildInputs = [ cstruct lwt ];

  doCheck = true;
  checkInputs = [ ounit2 ];

  meta = with lib; {
    description = "Xenstore protocol in pure OCaml";
    license = licenses.lgpl21Only;
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://github.com/mirage/ocaml-xenstore";
  };
}
