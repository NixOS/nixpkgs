{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f8ae7f5bdf75671a718d2daf0a64b7885f74510bcd98b1a0bb420eb9a9d0cff";
  };

  checkPhase = ''
    py.test
  '';

  # To prevent infinite recursion with pytest
  doCheck = false;

  meta = {
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://pypi.python.org/pypi/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jgeerds ];
  };
}