{ lib, buildDunePackage, fetchurl
, cstruct, ppx_cstruct, lwt, ounit2
}:

buildDunePackage rec {
  pname = "xenstore";
  version = "2.2.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-xenstore/releases/download/v${version}/xenstore-${version}.tbz";
    hash = "sha256-1Mnqtt5zHeRdYJHvhdQNjN8d4yxUEKD2cpwtoc7DGC0=";
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
