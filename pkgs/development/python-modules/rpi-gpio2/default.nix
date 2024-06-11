{
  lib,
  libgpiod,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "rpi-gpio2";
  version = "0.4.0";
  format = "setuptools";

  # PyPi source does not work for some reason
  src = fetchFromGitHub {
    owner = "underground-software";
    repo = "RPi.GPIO2";
    rev = "refs/tags/v${version}";
    hash = "sha256-CNnej67yTh3C8n4cCA7NW97rlfIDrrlepRNDkv+BUeY=";
  };

  propagatedBuildInputs = [ libgpiod ];

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
