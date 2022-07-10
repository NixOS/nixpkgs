{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, importlib-metadata
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  version = "4.1.0";
  pname = "humanize";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-humanize";
    repo = pname;
    rev = version;
    hash = "sha256-5xL3gfEohDjnF085Pgx/PBXWWM76X4FU2KR+8OGshMw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    setuptools
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "humanize"
  ];

  meta = with lib; {
    description = "Python humanize utilities";
    homepage = "https://github.com/python-humanize/humanize";
    license = licenses.mit;
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
