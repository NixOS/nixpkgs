{
  lib,
  buildDunePackage,
  fetchurl,
  alcotest,
}:

buildDunePackage rec {
  pname = "type_eq";
  version = "0.0.1";

  minimalOCamlVersion = "4.08.1";

  src = fetchurl {
    url = "https://github.com/skolemlabs/type_eq/releases/download/${version}/${pname}-${version}.tbz";
    hash = "sha256-4u/HF92Hbf9Rcv+JTAMPhYZjoKZ1cS0mBMkzU/hxx38=";
  };

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  meta = {
    description = "Type equality proofs for OCaml 4";
    homepage = "https://github.com/skolemlabs/type_eq";
    changelog = "https://github.com/skolemlabs/type_eq/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sixstring982 ];
  };
}
