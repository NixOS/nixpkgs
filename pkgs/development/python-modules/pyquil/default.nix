{ lib
, buildPythonPackage
, deprecated
, fetchFromGitHub
, importlib-metadata
, ipython
, lark
, matplotlib-inline
, nest-asyncio
, networkx
, numpy
, packaging
, poetry-core
, pydantic
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, qcs-sdk-python
, respx
, rpcq
, scipy
, syrupy
, tenacity
, types-deprecated
, types-python-dateutil
, types-retry
}:

buildPythonPackage rec {
  pname = "pyquil";
  version = "4.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "pyquil";
    rev = "refs/tags/v${version}";
    hash = "sha256-jzQv9XBJSxdpSWDEEPuHwYfIemelpmVKJUigpz6NWdo=";
  };

  pythonRelaxDeps = [
    "lark"
    "networkx"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    deprecated
    lark
    matplotlib-inline
    networkx
    numpy
    packaging
    pydantic
    qcs-sdk-python
    rpcq
    scipy
    tenacity
    types-deprecated
    types-python-dateutil
    types-retry
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
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

  pythonImportsCheck = [
    "pyquil"
  ];

  meta = with lib; {
    description = "Python library for creating Quantum Instruction Language (Quil) programs";
    homepage = "https://github.com/rigetti/pyquil";
    changelog = "https://github.com/rigetti/pyquil/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
