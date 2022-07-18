{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "autopage";
  version = "0.5.1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ab4+5hu3FOkJD8xcEPTPVGw5YzHGIMauUKIyGyjtMZk=";
  };

  pythonImportsCheck = [ "autopage" ];

  meta = with lib; {
    description = "A library to provide automatic paging for console output";
    homepage = "https://github.com/zaneb/autopage";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
