{ lib, fetchPypi, buildPythonPackage, flake8, pycodestyle, pytestrunner, pytest }:

buildPythonPackage rec {
  pname = "flake8-debugger";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e662f7e75a3ed729d3be7c92e72bde385ab08ec26e7808bf3dfc63445c87857";
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
