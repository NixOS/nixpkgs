{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyweatherflowrest";
  version = "1.0.11";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "briis";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-l1V3HgzqnnoY6sWHwfgBtcIR782RwKhekY2qOLrUMNY=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests. test.py is a demo script
  doCheck = false;

  pythonImportsCheck = [ "pyweatherflowrest" ];

  meta = with lib; {
    description = "Python module to get data from WeatherFlow Weather Stations";
    homepage = "https://github.com/briis/pyweatherflowrest";
    changelog = "https://github.com/briis/pyweatherflowrest/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
