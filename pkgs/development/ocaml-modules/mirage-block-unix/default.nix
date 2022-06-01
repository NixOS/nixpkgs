{ lib, fetchurl, buildDunePackage, cstruct-lwt, diet, io-page, logs
, mirage-block, ounit, rresult, uri }:

buildDunePackage rec {
  pname = "mirage-block-unix";
  version = "2.14.0";

  useDune2 = true;

  src = fetchurl {
    url =
      "https://github.com/mirage/mirage-block-unix/releases/download/v${version}/mirage-block-unix-${version}.tbz";
    sha256 = "sha256-wyG5JGIeMGxx3XtbIl9ZrQ04nm9aPSvXf6CNdt9yPbU=";
  };

  minimumOCamlVersion = "4.06";

  propagatedBuildInputs = [ cstruct-lwt logs mirage-block rresult uri ];

  doCheck = true;
  checkInputs = [ diet io-page ounit ];

  meta = with lib; {
    description = "MirageOS disk block driver for Unix";
    homepage = "https://github.com/mirage/mirage-block-unix";
    license = licenses.isc;
    maintainers = with maintainers; [ ehmry ];
  };
}
