{
  lib,
  fetchPypi,
  buildPythonPackage,
  persistent,
  setuptools,
  zope-interface,
  transaction,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "btrees";
  version = "6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "BTrees";
    inherit version;
    hash = "sha256-9puM3TNDThPhgCFruCrgt80x+t+3zFWWlcs3MZyjX/A=";
  };

  build-system = [
    persistent
    setuptools
  ];

  dependencies = [
    persistent
    zope-interface
  ];

  nativeCheckInputs = [
    transaction
    pytestCheckHook
  ];

  preCheck = ''
    pushd $out
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [
    "BTrees.OOBTree"
    "BTrees.IOBTree"
    "BTrees.IIBTree"
    "BTrees.IFBTree"
  ];

  meta = with lib; {
    description = "Scalable persistent components";
    homepage = "http://packages.python.org/BTrees";
    license = licenses.zpl21;
    maintainers = with maintainers; [ ];
  };
}
