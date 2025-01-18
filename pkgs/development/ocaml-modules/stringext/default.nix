{
  lib,
  fetchurl,
  ocaml,
  buildDunePackage,
  ounit,
  qtest,
  # Optionally enable tests; test script use OCaml-4.01+ features
  doCheck ? lib.versionAtLeast ocaml.version "4.08",
}:

let
  version = "1.6.0";
in

buildDunePackage {
  pname = "stringext";
  version = version;
  duneVersion = "3";
  src = fetchurl {
    url = "https://github.com/rgrinberg/stringext/releases/download/${version}/stringext-${version}.tbz";
    sha256 = "1sh6nafi3i9773j5mlwwz3kxfzdjzsfqj2qibxhigawy5vazahfv";
  };

  checkInputs = [
    ounit
    qtest
  ];
  inherit doCheck;

  meta = with lib; {
    homepage = "https://github.com/rgrinberg/stringext";
    description = "Extra string functions for OCaml";
    license = licenses.mit;
    maintainers = with maintainers; [ vbgl ];
  };
}
