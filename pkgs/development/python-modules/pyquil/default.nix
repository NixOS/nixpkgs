{
  lib,
  buildPythonPackage,
  deprecated,
  fetchFromGitHub,
  ipython,
  lark,
  matplotlib-inline,
  nest-asyncio,
  networkx,
  numpy,
  packaging,
  poetry-core,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  qcs-sdk-python,
  respx,
  rpcq,
  scipy,
  syrupy,
  tenacity,
  types-deprecated,
  types-python-dateutil,
  types-retry,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pyquil";
  version = "4.9.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "pyquil";
    rev = "refs/tags/v${version}";
    hash = "sha256-TxmQ9QXTTr4Xv37WmgArfK8Q5H1zAu8qx8wRsvK+vVM=";
  };

  pythonRelaxDeps = [
    "lark"
    "networkx"
    "packaging"
    "qcs-sdk-python"
  ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [
    deprecated
    lark
    matplotlib-inline
    networkx
    numpy
    packaging
    qcs-sdk-python
    rpcq
    scipy
    tenacity
    types-deprecated
    types-python-dateutil
    types-retry
    typing-extensions
  ];

  nativeCheckInputs = [
    nest-asyncio
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    respx
    syrupy
    ipython
  ];

  # tests hang
  doCheck = false;

  pythonImportsCheck = [ "pyquil" ];

  meta = with lib; {
    description = "Python library for creating Quantum Instruction Language (Quil) programs";
    homepage = "https://github.com/rigetti/pyquil";
    changelog = "https://github.com/rigetti/pyquil/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
