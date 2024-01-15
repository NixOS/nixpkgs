{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, aiohttp
, demjson3
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "pysyncthru";
  version = "0.8.0";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = "pysyncthru";
    rev = "refs/tags/${version}";
    hash = "sha256-Zije1WzfgIU9pT0H7T/Mx+5gEBCsRgMLkfsa/KB0YtI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    demjson3
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "pysyncthru" ];

  meta = with lib; {
    description = "Automated JSON API based communication with Samsung SyncThru Web Service";
    homepage = "https://github.com/nielstron/pysyncthru";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
