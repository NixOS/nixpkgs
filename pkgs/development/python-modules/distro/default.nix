{ lib, fetchFromGitHub, buildPythonPackage }:

buildPythonPackage rec {
  pname = "distro";
  version = "1.6.0";

  src = fetchFromGitHub {
     owner = "nir0s";
     repo = "distro";
     rev = "v1.6.0";
     sha256 = "157yyhw5y8z7ib2zks887a10jxg0a1l8ffiprzrrzgxl0ghybcnb";
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
