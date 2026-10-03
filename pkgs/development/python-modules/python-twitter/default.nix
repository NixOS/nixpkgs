{
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  filetype,
  future,
  hypothesis,
  lib,
  pytestCheckHook,
  requests,
  requests-oauthlib,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-twitter";
  version = "3.5";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "bear";
    repo = "python-twitter";
    rev = "v${version}";
    hash = "sha256-H8FkjeQ6fUz8gC65KlwQOi3zdecBd8M3M4E01oyrzSM=";
  };

  patches = [
    # Fix tests. Remove with the next release
    (fetchpatch {
      url = "https://github.com/bear/python-twitter/commit/f7eb83d9dca3ba0ee93e629ba5322732f99a3a30.patch";
      sha256 = "008b1bd03wwngs554qb136lsasihql3yi7vlcacmk4s5fmr6klqw";
    })
  ];

  dependencies = [
    filetype
    future
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
    hypothesis
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'" ""
  '';

  disabledTests = [
    # AttributeError: 'FileCacheTest' object has no attribute 'assert_'
    "test_filecache"
  ];

  pythonImportsCheck = [ "twitter" ];

  meta = {
    description = "Python wrapper around the Twitter API";
    homepage = "https://github.com/bear/python-twitter";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
