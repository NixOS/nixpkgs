{ lib, buildDunePackage, fetchurl
, ptime, qcheck
}:

buildDunePackage rec {
  pname = "syslog-message";
  version = "1.2.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/verbosemode/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    hash = "sha256-+eyiv6JvC0EKs3G1s5qoFtK0bU4Yg41AHg5Nc6xD9w0=";
  };

  propagatedBuildInputs = [
    ptime
  ];

  doCheck = true;
  checkInputs = [
    qcheck
  ];

  meta = with lib; {
    description = "Syslog message parser";
    homepage = "https://github.com/verbosemode/syslog-message";
    license = licenses.bsd2;
    maintainers = [ maintainers.sternenseemann ];
  };
}
