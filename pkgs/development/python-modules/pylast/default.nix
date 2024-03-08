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
  version = "5.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pylast";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-6yxsqruosSOJ5LeIBbvuEko4s9qU/ObNZiJD5YH/hvY=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    httpx
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
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
