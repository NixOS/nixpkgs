{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools-scm
, vcver
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "deepmerge";
  version = "0.2.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "082bvlk65pkf9qzkzzl8fq7s6zfz1b2v5pcb0ikwg1nx0xspggaz";
  };

  nativeBuildInputs = [
    setuptools-scm
    vcver
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "deepmerge" ];

  meta = with lib; {
    description = "A toolset to deeply merge python dictionaries.";
    homepage = "http://deepmerge.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
