{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "distro";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09441261dd3c8b2gv15vhw1cryzg60lmgpkk07v6hpwwkyhfbxc3";
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
