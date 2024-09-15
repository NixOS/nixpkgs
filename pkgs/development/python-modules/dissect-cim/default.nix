{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dissect-cim";
  version = "3.10";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cim";
    rev = "refs/tags/${version}";
    hash = "sha256-7Mv8yiWEs/mj/JKDrD1BxT75tQr13VgGj0yHdRltcYM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.cim" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the Windows Common Information Model (CIM) database";
    homepage = "https://github.com/fox-it/dissect.cim";
    changelog = "https://github.com/fox-it/dissect.cim/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
