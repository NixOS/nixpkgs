{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ounit,
  qcheck,
}:

buildDunePackage rec {
  pname = "bencode";
  version = "2.0";
  minimalOCamlVersion = "4.02.0";

  src = fetchFromGitHub {
    owner = "rgrinberg";
    repo = "bencode";
    tag = version;
    hash = "sha256-sEMS9oBOPeFX1x7cHjbQhCD2QI5yqC+550pPqqMsVws=";
  };

  doCheck = true;
  checkInputs = [
    ounit
    qcheck
  ];

  meta = {
    description = "Bencode (.torrent file format) reader/writer in OCaml ";
    homepage = "https://github.com/rgrinberg/bencode";
    changelog = "https://github.com/rgrinberg/bencode/blob/${version}/Changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
