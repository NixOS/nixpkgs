{ buildPythonPackage
, lib
, fetchPypi
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "447ba94990e8014ee25ec853339faf7b0fc8050cdc3289d4d71f7f410fb90095";
  };

  checkPhase = ''
    py.test
  '';

  # To prevent infinite recursion with pytest
  doCheck = false;

  buildInputs = [ setuptools_scm ];

  meta = {
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://pypi.python.org/pypi/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jgeerds ];
  };
}