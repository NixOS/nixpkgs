{
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  filetype,
  future,
  hypothesis,
  lib,
  pytestCheckHook,
  pythonOlder,
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

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bear";
    repo = pname;
    rev = "v${version}";
    sha256 = "08ydmf6dcd416cvw6xq1wxsz6b9s21f2mf9fh3y4qz9swj6n9h8z";
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

  meta = with lib; {
    description = "Python wrapper around the Twitter API";
    homepage = "https://github.com/bear/python-twitter";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
