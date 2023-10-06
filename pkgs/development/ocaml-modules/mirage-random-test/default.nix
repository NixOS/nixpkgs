{ lib, buildDunePackage, fetchurl
, cstruct, mirage-random
}:

buildDunePackage rec {
  pname = "mirage-random-test";
  version = "0.1.0";

  minimalOCamlVersion = "4.06";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "1jmjyb9a4v7l0xxgdwpr9zshzr8xk3hybra6y2dp51anbwk8kv46";
  };

  propagatedBuildInputs = [
    cstruct
    mirage-random
  ];

  meta = with lib; {
    description = "Stub random device implementation for testing";
    homepage = "https://github.com/mirage/mirage-random";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
