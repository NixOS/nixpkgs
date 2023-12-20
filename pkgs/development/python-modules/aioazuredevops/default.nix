{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, aiohttp
, click
}:

buildPythonPackage rec {
  pname = "aioazuredevops";
  version = "1.4.3";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vNTvSQYjjptdPsHz0zM9paq3iodZrhcEralPm6YRZJE=";
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
