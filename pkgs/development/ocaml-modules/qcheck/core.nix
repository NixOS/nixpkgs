{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "qcheck-core";
  version = "0.15";

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "qcheck";
    rev = version;
    sha256 = "1ywaklqm1agvxvzv7pwl8v4zlwc3ykw6l251w43f0gy9cfwqmh3j";
  };

  meta = {
    description = "Core qcheck library";
    homepage = "https://c-cube.github.io/qcheck/";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
