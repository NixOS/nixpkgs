{ lib, buildDunePackage, io-page, cstruct, ounit }:

buildDunePackage {
  pname = "io-page-unix";

  inherit (io-page) version src minimumOCamlVersion;

  propagatedBuildInputs = [ cstruct io-page ];
  checkInputs = [ ounit ];
  doCheck = true;

  meta = with lib; {
    inherit (io-page.meta) homepage license;
    description = "Support for efficient handling of I/O memory pages on Unix";
    maintainers = [ maintainers.sternenseemann ];
  };
}
