{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, aiohttp
, click
}:

buildPythonPackage rec {
  pname = "aioazuredevops";
  version = "1.3.5";

  disabled = isPy27;

  src = fetchFromGitHub {
     owner = "timmo001";
     repo = "aioazuredevops";
     rev = "v1.3.5";
     sha256 = "033710qa0l7r67x9813kr5ari5p2qrf1zjp1zj2c8wvd084h8jfy";
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
