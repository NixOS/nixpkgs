{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, aiohttp
, click
}:

buildPythonPackage rec {
  pname = "aioazuredevops";
  version = "1.3.5";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c98a995d0516f502ba191fa3ac973ee72b93425e7eab3cdf770516c6e93c780";
  };

  propagatedBuildInputs = [
    aiohttp
    click
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "aioazuredevops.builds"
    "aioazuredevops.client"
    "aioazuredevops.core"
  ];

  meta = with lib; {
    description = "Get data from the Azure DevOps API";
    homepage = "https://github.com/timmo001/aioazuredevops";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
