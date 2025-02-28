{
  lib,
  fetchurl,
  buildDunePackage,
  cstruct-lwt,
  diet,
  logs,
  mirage-block,
  ounit2,
  rresult,
  uri,
}:

buildDunePackage rec {
  pname = "mirage-block-unix";
  version = "2.14.2";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-block-unix/releases/download/v${version}/mirage-block-unix-${version}.tbz";
    sha256 = "sha256-6ReAzd+pCd5ccmXOh6GlSxHo4GuEgptxLha62n+dBsE=";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [
    cstruct-lwt
    logs
    mirage-block
    rresult
    uri
  ];

  doCheck = true;
  checkInputs = [
    diet
    ounit2
  ];

  meta = with lib; {
    description = "MirageOS disk block driver for Unix";
    homepage = "https://github.com/mirage/mirage-block-unix";
    license = licenses.isc;
    maintainers = with maintainers; [ ehmry ];
  };
}
