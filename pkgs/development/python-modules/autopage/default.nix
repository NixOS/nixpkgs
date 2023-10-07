{ lib, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "autopage";
  version = "0.5.1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ab4+5hu3FOkJD8xcEPTPVGw5YzHGIMauUKIyGyjtMZk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [ "autopage" ];

  meta = with lib; {
    description = "A library to provide automatic paging for console output";
    homepage = "https://github.com/zaneb/autopage";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
