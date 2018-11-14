{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-repeat";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0axbrpqal3cqw9zq6dakdbg49pnf5gvyvq6yn93hp1ayc7fnhzk3";
  };

  buildInputs = [ setuptools_scm pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Pytest plugin for repeating tests";
    homepage = https://github.com/pytest-dev/pytest-repeat;
    maintainers = with lib.maintainers; [ costrouc ];
    license = lib.licenses.mpl20;
  };
}
