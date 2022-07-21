{ lib, buildDunePackage, fetchurl
, alcotest
, astring, fmt
}:

buildDunePackage rec {
  pname = "domain-name";
  version = "0.4.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/hannesm/domain-name/releases/download/v${version}/domain-name-${version}.tbz";
    sha256 = "sha256-pcBuIoRYlSAZc+gS/jAZJ00duBwKeHPabIAHxK0hCMU=";
  };

  minimumOCamlVersion = "4.03";

  checkInputs = [ alcotest ];

  propagatedBuildInputs = [ astring fmt ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/hannesm/domain-name";
    description = "RFC 1035 Internet domain names";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
