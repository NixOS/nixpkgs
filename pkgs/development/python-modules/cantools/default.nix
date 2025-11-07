{
  lib,
  argparse-addons,
  bitstruct,
  buildPythonPackage,
  python-can,
  crccheck,
  diskcache,
  fetchPypi,
  matplotlib,
  parameterized,
  pytest-freezegun,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  textparser,
}:

buildPythonPackage rec {
  pname = "cantools";
  version = "40.7.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rn4EzIbgdjBzda6bzYNwcQjpmOPqYBm/lodzWAuaqV8=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    argparse-addons
    bitstruct
    python-can
    crccheck
    diskcache
    textparser
  ];

  optional-dependencies.plot = [ matplotlib ];

  nativeCheckInputs = [
    parameterized
    pytest-freezegun
    pytestCheckHook
  ]
  ++ optional-dependencies.plot;

  pythonImportsCheck = [ "cantools" ];

  meta = with lib; {
    description = "Tools to work with CAN bus";
    homepage = "https://github.com/cantools/cantools";
    changelog = "https://github.com/cantools/cantools/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gray-heron ];
    mainProgram = "cantools";
  };
}
