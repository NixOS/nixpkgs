{ lib, buildDunePackage, fetchurl
, cstruct, ppx_cstruct, lwt, ounit, stdlib-shims
}:

buildDunePackage rec {
  pname = "xenstore";
  version = "2.1.1";

  minimumOCamlVersion = "4.04";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-xenstore/releases/download/${version}/xenstore-${version}.tbz";
    sha256 = "283814ea21adc345c4d59cfcb17b2f7c1185004ecaecc3871557c961874c84f5";
  };

  nativeBuildInputs = [ ppx_cstruct ];
  propagatedBuildInputs = [ stdlib-shims cstruct lwt ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = with lib; {
    description = "Xenstore protocol in pure OCaml";
    license = licenses.lgpl21Only;
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://github.com/mirage/ocaml-xenstore";
  };
}
