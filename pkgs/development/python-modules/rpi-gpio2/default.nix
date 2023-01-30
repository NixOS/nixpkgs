{ lib, libgpiod, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "rpi-gpio2";
  version = "0.3.0a3";

  # PyPi source does not work for some reason
  src = fetchFromGitHub {
    owner = "underground-software";
    repo = "RPi.GPIO2";
    rev = "v${version}";
    hash = "sha256-8HQbEnO+4Ppo2Z3HBulbBcSKJF1bNNQYz8k6aUt65oc=";
  };

  propagatedBuildInputs = [
    libgpiod
  ];

  # Disable checks because they need to run on the specific platform
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/underground-software/RPi.GPIO2";
    description = ''
      Compatibility layer between RPi.GPIO syntax and libgpiod semantics
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
