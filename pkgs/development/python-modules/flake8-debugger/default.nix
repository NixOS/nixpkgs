{ lib, fetchPypi, buildPythonPackage, pythonOlder, pythonAtLeast, isPy27
, flake8
, pycodestyle
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flake8-debugger";
  version = "4.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e43dc777f7db1481db473210101ec2df2bd39a45b149d7218a618e954177eda6";
  };

  propagatedBuildInputs = [ flake8 pycodestyle six ];

  checkInputs = [ pytestCheckHook ];

  # Tests not included in PyPI tarball
  # FIXME: Remove when https://github.com/JBKahn/flake8-debugger/pull/15 is merged
  doCheck = false;

  meta = {
    homepage = "https://github.com/jbkahn/flake8-debugger";
    description = "ipdb/pdb statement checker plugin for flake8";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.mit;
  };
}
