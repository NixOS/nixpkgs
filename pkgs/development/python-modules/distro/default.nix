{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "distro";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83f5e5a09f9c5f68f60173de572930effbcc0287bb84fdc4426cb4168c088424";
  };

  # tests are very targeted at individual linux distributions
  doCheck = false;

  pythonImportsCheck = [ "distro" ];

  meta = with lib; {
    homepage = "https://github.com/nir0s/distro";
    description = "Linux Distribution - a Linux OS platform information API.";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
