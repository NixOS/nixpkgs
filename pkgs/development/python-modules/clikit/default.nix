{
  lib,
  buildPythonPackage,
  crashtest,
  fetchFromGitHub,
  pastel,
  poetry-core,
  pylev,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "clikit";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sdispater";
    repo = "clikit";
    tag = version;
    hash = "sha256-xAsUNhVQBjtSFHyjjnicAKRC3+Tdn3AdGDUYhmOOIdA=";
  };

  pythonRelaxDeps = [ "crashtest" ];

  build-system = [ poetry-core ];

  dependencies = [
    crashtest
    pastel
    pylev
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "clikit" ];

  meta = {
    description = "Group of utilities to build beautiful and testable command line interfaces";
    homepage = "https://github.com/sdispater/clikit";
    changelog = "https://github.com/sdispater/clikit/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jakewaksbaum ];
  };
}
