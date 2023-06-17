{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, requests
, uritemplate
, python-dateutil
, pyjwt
, pytestCheckHook
, betamax
, betamax-matchers
}:

buildPythonPackage rec {
  pname = "github3.py";
  version = "3.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Cbcr4Ul9NGsJaM3oNgoNavedwgbQFJpjzT7IbGXDd8w=";
  };

  propagatedBuildInputs = [
    requests
    uritemplate
    python-dateutil
    pyjwt
  ]
  ++ pyjwt.optional-dependencies.crypto;

  nativeCheckInputs = [
    pytestCheckHook
    betamax
    betamax-matchers
  ];

  # Solves "__main__.py: error: unrecognized arguments: -nauto"
  preCheck = ''
    rm tox.ini
  '';

  disabledTests = [
    # FileNotFoundError: [Errno 2] No such file or directory: 'tests/id_rsa.pub'
    "test_delete_key"
  ];

  meta = with lib; {
    homepage = "https://github3py.readthedocs.org/en/master/";
    description = "A wrapper for the GitHub API written in python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
  };
}
