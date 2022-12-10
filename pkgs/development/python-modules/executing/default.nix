{ lib
, asttokens
, buildPythonPackage
, fetchFromGitHub
, littleutils
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, rich
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "executing";
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3M3uSJ5xQ5Ciy8Lz21u9zjju/7SBSFHobCqSiJ6AP8M=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    asttokens
    littleutils
    pytestCheckHook
  ] ++ lib.optionals (pythonAtLeast "3.11") [
    rich
  ];

  pythonImportsCheck = [
    "executing"
  ];

  meta = with lib; {
    description = "Get information about what a frame is currently doing, particularly the AST node being executed";
    homepage = "https://github.com/alexmojaki/executing";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
  };
}
