{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "distro";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FRrsz2DCFkApMrUuQO5HepOfjViJiSc3igKrvoUsHDk=";
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
