{ lib
, asttokens
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pytestCheckHook
, littleutils
, pythonAtLeast
, rich
}:

buildPythonPackage rec {
  pname = "executing";
  version = "1.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3M3uSJ5xQ5Ciy8Lz21u9zjju/7SBSFHobCqSiJ6AP8M=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
  '';

  checkInputs = [
    pytestCheckHook
    asttokens
    littleutils
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
