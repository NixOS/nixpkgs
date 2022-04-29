{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "autopage";
  version = "0.5.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UwW0PMB5gXDXEk5aL+7Plp5F9KC691yzUROBFOr3a4M=";
  };

  pythonImportsCheck = [ "autopage" ];

  meta = with lib; {
    description = "A library to provide automatic paging for console output";
    homepage = "https://github.com/zaneb/autopage";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
