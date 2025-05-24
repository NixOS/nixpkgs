{
  lib,
  buildDunePackage,
  fetchurl,
  ounit,
  qcheck,
}:

buildDunePackage rec {
  pname = "bencode";
  version = "2.0";
  minimalOCamlVersion = "4.02.0";

  src = fetchurl {
    url = "https://github.com/rgrinberg/bencode/archive/${version}.tar.gz";
    hash = "sha256-Iz6uCBcSbpxKeBvxMp2DRnK3eVTmuYOk0KKY0eL/B1Y=";
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
