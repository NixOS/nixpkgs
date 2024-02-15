{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "lml";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57a085a29bb7991d70d41c6c3144c560a8e35b4c1030ffb36d85fa058773bcc5";
  };

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  # Tests broken.
  doCheck = false;

  meta = {
    description = "Load me later. A lazy plugin management system for Python";
    homepage = "http://lml.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
