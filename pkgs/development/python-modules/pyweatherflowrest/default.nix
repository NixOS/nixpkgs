{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pyweatherflowrest";
  version = "1.0.9";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "briis";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-LFA1GJCYFIWl7/YblRrYgAB4lbELpzhCJyjB8aCkJ/E=";
  };

  nativeBuildInputs = [
    setuptools
  ];


  propagatedBuildInputs = [
    aiohttp
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=pyweatherflowrest --cov-append" ""
  '';

  # Module has no tests. test.py is a demo script
  doCheck = false;

  pythonImportsCheck = [
    "pyweatherflowrest"
  ];

  meta = with lib; {
    description = "Python module to get data from WeatherFlow Weather Stations";
    homepage = "https://github.com/briis/pyweatherflowrest";
    changelog = "https://github.com/briis/pyweatherflowrest/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
