{ lib, buildDunePackage, fetchurl, lwt }:

buildDunePackage rec {
  pname = "lwt-dllist";
  version = "1.0.0";

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "0g111f8fq9k1hwccpkhylkp83f73mlz4xnxxr3rf9xpi2f8fh7j9";
  };

  propagatedBuildInputs = [
    lwt
  ];

  doCheck = true;

  meta = with lib; {
    description = "Mutable doubly-linked list with Lwt iterators";
    homepage = "https://github.com/mirage/lwt-dllist";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
