{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  requests,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "reconspread";
  version = "0.1.0-unstable-2025-07-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reconurge";
    repo = "reconspread";
    # https://github.com/reconurge/reconspread/issues/1
    rev = "118f8fb7a0d4e6e5ec2d78999f89ce168aa8429a";
    hash = "sha256-7lsCuSmUwz/PfgWmy2vIyMcjxuRz7Lb0TM1Ax9BJruU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    lxml
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "reconspread" ];

  meta = {
    description = "Module to extract links";
    homepage = "https://github.com/reconurge/reconspread";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
