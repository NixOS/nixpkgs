{ lib, fetchPypi, buildPythonPackage, pythonOlder
, flake8
, importlib-metadata
, pycodestyle
, pytestrunner
, pytest
}:

buildPythonPackage rec {
  pname = "flake8-debugger";
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "712d7c1ff69ddf3f0130e94cc88c2519e720760bce45e8c330bfdcb61ab4090d";
  };

  nativeBuildInputs = [ pytestrunner ];

  propagatedBuildInputs = [ flake8 pycodestyle ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  checkInputs = [ pytest ];

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
