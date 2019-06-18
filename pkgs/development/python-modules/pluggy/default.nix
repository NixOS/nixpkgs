{ buildPythonPackage
, lib
, fetchPypi
, setuptools_scm
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0825a152ac059776623854c1543d65a4ad408eb3d33ee114dff91e57ec6ae6fc";
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
