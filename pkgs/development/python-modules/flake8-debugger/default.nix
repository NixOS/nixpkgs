{ lib, fetchPypi, buildPythonPackage, isPy27
, flake8
, pycodestyle
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flake8-debugger";
  version = "4.1.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UrACVglB422b+Ab8olI9x/uFYKKV1fGm4VrC3tenOEA=";
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
