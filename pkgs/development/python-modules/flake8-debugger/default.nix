{ lib, fetchPypi, buildPythonPackage, flake8, pycodestyle, pytestrunner, pytest }:

buildPythonPackage rec {
  pname = "flake8-debugger";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "103d86d2ecb95f8aab90f90603446f4e2bb60e01f1593e4fec410074dedabac6";
  };

  nativeBuildInputs = [ pytestrunner ];

  propagatedBuildInputs = [ flake8 pycodestyle ];

  checkInputs = [ pytest ];

  # Tests not included in PyPI tarball
  # FIXME: Remove when https://github.com/JBKahn/flake8-debugger/pull/15 is merged
  doCheck = false;

  meta = {
    homepage = https://github.com/jbkahn/flake8-debugger;
    description = "ipdb/pdb statement checker plugin for flake8";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.mit;
  };
}
