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
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2560a9b27d59bb17810d12ec3402dfc7c8e100e40539a70d2814bcbb27240f27";
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
