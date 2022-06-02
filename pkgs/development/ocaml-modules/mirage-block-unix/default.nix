{ lib, fetchurl, buildDunePackage, cstruct-lwt, diet, io-page-unix, logs
, mirage-block, ounit, rresult, uri }:

buildDunePackage rec {
  pname = "mirage-block-unix";
  version = "2.12.1";

  useDune2 = true;

  src = fetchurl {
    url =
      "https://github.com/mirage/mirage-block-unix/releases/download/v${version}/mirage-block-unix-v${version}.tbz";
    sha256 = "4fc0ccea3c06c654e149c0f0e1c2a6f19be4e3fe1afd293c6a0dba1b56b3b8c4";
  };

  minimumOCamlVersion = "4.06";

  propagatedBuildInputs = [ cstruct-lwt logs mirage-block rresult uri ];

  doCheck = true;
  checkInputs = [ diet io-page-unix ounit ];

  meta = with lib; {
    description = "MirageOS disk block driver for Unix";
    homepage = "https://github.com/mirage/mirage-block-unix";
    license = licenses.isc;
    maintainers = with maintainers; [ ehmry ];
  };
}
