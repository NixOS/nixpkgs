{ buildPythonPackage
, lib
, fetchPypi
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25a1bc1d148c9a640211872b4ff859878d422bccb59c9965e04eed468a0aa180";
  };

  checkPhase = ''
    py.test
  '';

  # To prevent infinite recursion with pytest
  doCheck = false;

  buildInputs = [ setuptools_scm ];

  meta = {
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://github.com/pytest-dev/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
