{ lib, fetchPypi, buildPythonPackage, flake8, pycodestyle, pytestrunner, pytest }:

buildPythonPackage rec {
  pname = "flake8-debugger";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be4fb88de3ee8f6dd5053a2d347e2c0a2b54bab6733a2280bb20ebd3c4ca1d97";
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
