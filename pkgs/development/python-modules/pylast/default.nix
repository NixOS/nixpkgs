{ lib
, buildPythonPackage
, fetchFromGitHub
, flaky
, hatch-vcs
, hatchling
, httpx
, importlib-metadata
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylast";
  version = "5.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pylast";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-LRZYLo9h7Z8WXemLgKR5qzAmtL4x/AQQJpta3e0WHcc=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    httpx
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
    flaky
  ];

  pythonImportsCheck = [
    "pylast"
  ];

  meta = with lib; {
    description = "Python interface to last.fm (and compatibles)";
    homepage = "https://github.com/pylast/pylast";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab rvolosatovs ];
  };
}
