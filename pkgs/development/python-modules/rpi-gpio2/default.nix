{ lib, libgpiod, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  pname = "rpi-gpio2";
  version = "0.3.0a3";

  # PyPi source does not work for some reason
  src = fetchurl {
    url = "https://github.com/underground-software/RPi.GPIO2/archive/refs/tags/v${version}.tar.gz";
    sha256 = "sha256-AY1AD2Yu66eJUqB4OStZnUeEhmISLVRrTOAcmEHjuOM=";
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
