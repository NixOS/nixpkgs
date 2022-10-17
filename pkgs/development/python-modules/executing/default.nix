{ lib
, asttokens
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "executing";
  version = "0.8.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CDZQ9DONn7M+2/GtmM2G6nQPpI9dOd0ca+2F1PGRwO4=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
  '';

  # Tests appear to run fine (Ran 22 tests in 4.076s) with setuptoolsCheckPhase
  # but crash with pytestCheckHook
  checkInputs = [
    asttokens
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
