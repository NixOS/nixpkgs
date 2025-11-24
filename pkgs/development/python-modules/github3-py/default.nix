{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  uritemplate,
  python-dateutil,
  pyjwt,
  pytest-xdist,
  pytestCheckHook,
  betamax,
  betamax-matchers,
  hatchling,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "github3-py";
  version = "4.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "github3.py";
    inherit version;
    hash = "sha256-MNVxB2dT78OJ7cf5qu8zik/LJLVNiWjV85sTQvRd3TY=";
  };

  patches = [
    (fetchpatch {
      # disable tests with "AttributeError: 'MockHTTPResponse' object has no attribute 'close'", due to betamax
      url = "https://github.com/sigmavirus24/github3.py/commit/9d6124c09b0997b5e83579549bcf22b3e901d7e5.patch";
      hash = "sha256-8Z4vN7iKl/sOcEJptsH5jsqijZgvL6jS7kymZ8+m6bY=";
    })
  ];

  build-system = [ hatchling ];

  dependencies = [
    pyjwt
    python-dateutil
    requests
    uritemplate
  ]
  ++ pyjwt.optional-dependencies.crypto;

  pythonImportsCheck = [ "github3" ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    betamax
    betamax-matchers
  ];

  meta = {
    homepage = "https://github3py.readthedocs.org/en/master/";
    description = "Wrapper for the GitHub API written in python";
    changelog = "https://github.com/sigmavirus24/github3.py/blob/${version}/docs/source/release-notes/${version}.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pSub ];
  };
}
