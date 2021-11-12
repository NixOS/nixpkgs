{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "autopage";
  version = "0.4.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18f511d8ef2e4d3cc22a986d345eab0e03f95b9fa80b74ca63b7fb001551dc42";
  };

  pythonImportsCheck = [ "autopage" ];

  meta = with lib; {
    description = "A library to provide automatic paging for console output";
    homepage = "https://github.com/zaneb/autopage";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
