{
  lib,
  betamax,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests-toolbelt,
  setuptools,
}:

buildPythonPackage rec {
  pname = "betamax-matchers";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "betamaxpy";
    repo = "betamax_matchers";
    tag = version;
    hash = "sha256-BV9DOfZLDAZIr2E75l988QxFWWvazBL9VttxGFIez1M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    betamax
    requests-toolbelt
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "betamax_matchers" ];

  meta = with lib; {
    description = "Group of experimental matchers for Betamax";
    homepage = "https://github.com/sigmavirus24/betamax_matchers";
    changelog = "https://github.com/betamaxpy/betamax_matchers/blob/${version}/HISTORY.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
  };
}
