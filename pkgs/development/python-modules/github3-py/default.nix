{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  requests,
  uritemplate,
  python-dateutil,
  pyjwt,
  pytestCheckHook,
  betamax,
  betamax-matchers,
  hatchling,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "github3.py";
  version = "4.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MNVxB2dT78OJ7cf5qu8zik/LJLVNiWjV85sTQvRd3TY=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    pyjwt
    python-dateutil
    requests
    uritemplate
  ] ++ pyjwt.optional-dependencies.crypto;

  nativeCheckInputs = [
    pytestCheckHook
    betamax
    betamax-matchers
  ];

  patches = [
    (fetchpatch {
      # disable tests with "AttributeError: 'MockHTTPResponse' object has no attribute 'close'", due to betamax
      url = "https://github.com/sigmavirus24/github3.py/commit/9d6124c09b0997b5e83579549bcf22b3e901d7e5.patch";
      hash = "sha256-8Z4vN7iKl/sOcEJptsH5jsqijZgvL6jS7kymZ8+m6bY=";
    })
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
