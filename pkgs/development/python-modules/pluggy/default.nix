{ buildPythonPackage
, lib
, fetchPypi
, setuptools_scm
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa5fa1622fa6dd5c030e9cad086fa19ef6a0cf6d7a2d12318e10cb49d6d68f34";
  };

  checkPhase = ''
    py.test
  '';

  # To prevent infinite recursion with pytest
  doCheck = false;

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ importlib-metadata ];

  meta = {
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://github.com/pytest-dev/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
