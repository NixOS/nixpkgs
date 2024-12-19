{
  lib,
  buildPythonPackage,
  cacert,
  fetchFromGitHub,
  fetchpatch,
  git-annex,
  gitMinimal,
  pygit2,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  substituteAll,
  util-linux,
}:

buildPythonPackage rec {
  pname = "git-annex-adapter";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alpernebbi";
    repo = "git-annex-adapter";
    rev = "refs/tags/v${version}";
    hash = "sha256-vb0vxnwAs0/yOjpyyoGWvX6Tu+cuziGNdnXbdzXexhg=";
  };

  patches = [
    # fix tests with recent versions of git-annex
    (fetchpatch {
      url = "https://github.com/alpernebbi/git-annex-adapter/commit/6c210d828e8a57b12c716339ad1bf15c31cd4a55.patch";
      sha256 = "17kp7pnm9svq9av4q7hfic95xa1w3z02dnr8nmg14sjck2rlmqsi";
    })
    (fetchpatch {
      url = "https://github.com/alpernebbi/git-annex-adapter/commit/b78a8f445f1fb5cf34b28512fc61898ef166b5a1.patch";
      hash = "sha256-BSVoOPWsgY1btvn68bco4yb90FAC7ay2kYZ+q9qDHHw=";
    })
    (fetchpatch {
      url = "https://github.com/alpernebbi/git-annex-adapter/commit/d0d8905965a3659ce95cbd8f8b1e8598f0faf76b.patch";
      hash = "sha256-UcRTKzD3sbXGIuxj4JzZDnvjTYyWVkfeWgKiZ1rAlus=";
    })
    (substituteAll {
      src = ./git-annex-path.patch;
      gitAnnex = "${git-annex}/bin/git-annex";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pygit2
    cacert
  ];

  nativeCheckInputs = [
    gitMinimal
    util-linux # `rev` is needed in tests/test_process.py
    pytestCheckHook
  ];

  pythonImportsCheck = [ "git_annex_adapter" ];

  disabledTests = [
    # KeyError and AssertionError
    "test_annex_keys"
    "test_batchjson_metadata"
    "test_file_tree"
    "test_jsonprocess_annex_metadata_batch"
    "test_process_annex_metadata_batch"
  ];

  meta = with lib; {
    homepage = "https://github.com/alpernebbi/git-annex-adapter";
    description = "Call git-annex commands from Python";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
