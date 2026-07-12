{
  lib,
  buildDunePackage,
  fetchurl,
  re,
  result,
  seq,
  alcotest,
}:

buildDunePackage rec {
  pname = "tyre";
  version = "0.5";

  minimalOCamlVersion = "4.03.0";

  src = fetchurl {
    url = "https://github.com/Drup/tyre/releases/download/${version}/${pname}-${version}.tbz";
    hash = "sha256-eqB/racqpxu5hVlC4Os+4AfDOeYj4UXF3S/4Ckkem2k=";
  };

  propagatedBuildInputs = [
    re
    result
    seq
  ];

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  meta = {
    description = "Typed Regular Expressions";
    homepage = "https://github.com/Drup/tyre";
    changelog = "https://github.com/Drup/tyre/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
