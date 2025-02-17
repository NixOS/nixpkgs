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
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  textparser,
}:

buildPythonPackage rec {
  pname = "cantools";
  version = "40.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/HX5/ls375kvr9+YH/giCH4brxgWK7uzXYsLEyHtct8=";
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
    pytestCheckHook
  ] ++ optional-dependencies.plot;

  pythonImportsCheck = [ "cantools" ];

  meta = with lib; {
    description = "Tools to work with CAN bus";
    mainProgram = "cantools";
    homepage = "https://github.com/cantools/cantools";
    changelog = "https://github.com/cantools/cantools/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gray-heron ];
  };
}
