{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  deprecated,
  ipython,
  matplotlib-inline,
  nest-asyncio,
  networkx,
  numpy,
  packaging,
  poetry-core,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  qcs-sdk-python,
  respx,
  rpcq,
  scipy,
  syrupy,
  types-deprecated,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pyquil";
  version = "4.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "pyquil";
    tag = "v${version}";
    hash = "sha256-itDy42rhHiX9oXQQ+eKE3/Xdh4cBzdS3jetanTrxuFo=";
  };

  pythonRelaxDeps = [
    "lark"
    "networkx"
    "numpy"
    "packaging"
    "qcs-sdk-python"
    "rpcq"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    deprecated
    matplotlib-inline
    networkx
    numpy
    packaging
    qcs-sdk-python
    rpcq
    scipy
    types-deprecated
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

  meta = {
    description = "Python library for creating Quantum Instruction Language (Quil) programs";
    homepage = "https://github.com/rigetti/pyquil";
    changelog = "https://github.com/rigetti/pyquil/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
