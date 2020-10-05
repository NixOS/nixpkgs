{ lib
, buildPythonPackage
, fetchPypi
, filelock
, pytest
, mypy
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pytest-mypy";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a667d9a2b66bf98b3a494411f221923a6e2c3eafbe771104951aaec8985673d";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ pytest mypy filelock ];

  meta = with lib; {
    description = "Mypy static type checker plugin for Pytest";
    homepage = "https://github.com/dbader/pytest-mypy";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
