{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  minimalOCamlVersion = "4.06";
  duneVersion = "2";
  pname = "owee";
  version = "0.6";

  src = fetchurl {
    url =
      "https://github.com/let-def/owee/releases/download/v${version}/owee-${version}.tbz";
    sha256 = "sha256-GwXV5t4GYbDiGwyvQyW8NZoYvn4qXlLnjX331Bj1wjM=";
  };

  meta = with lib; {
    description = "An experimental OCaml library to work with DWARF format";
    homepage = "https://github.com/let-def/owee/";
    license = licenses.mit;
    maintainers = with maintainers; [ vbgl alizter ];
  };
}
