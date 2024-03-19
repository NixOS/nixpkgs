{ lib, buildDunePackage, fetchurl
, astring, ptime, rresult, qcheck
}:

buildDunePackage rec {
  pname = "syslog-message";
  version = "1.1.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/verbosemode/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    hash = "sha256:0vy4dkl2q2fa6rzyfsvjyc9r1b9ymfqd6j35z2kp5vdc4r87053g";
  };

  propagatedBuildInputs = [
    astring
    ptime
    rresult
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
