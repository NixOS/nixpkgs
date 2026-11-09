{
  lib,
  buildPythonPackage,
  cvxopt,
  fetchFromGitHub,
  fetchpatch,
  matplotlib,
  numpy,
  numpydoc,
  pytest-timeout,
  pytestCheckHook,
  scipy,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "control";
  version = "0.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-control";
    repo = "python-control";
    tag = version;
    hash = "sha256-E9RZDUK01hzjutq83XdLr3d97NwjmQzt65hqVg2TBGE=";
  };

  patches = [
    # matplotlib >= 3.11 no longer warns when tight layout is not applied
    (fetchpatch {
      url = "https://github.com/python-control/python-control/commit/3b70cb41b5d41ed4aa4da9f2db2eb3d83c3ffdcd.patch";
      hash = "sha256-zJAbgbeiYQlglG/mbtREvs7AFxwGxzlzrr0iuKPHp5I=";
    })
    # numpy >= 2.5 deprecates assigning to .shape
    (fetchpatch {
      url = "https://github.com/python-control/python-control/commit/ae4915c4ece5f417fa514dadeb0d30ab412a28aa.patch";
      hash = "sha256-Z5U9sgtlp35bHYOYC2ag9007fGVXwzhTgBQN7yLsjCI=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scipy
    matplotlib
  ];

  optional-dependencies = {
    # slycot is not in nixpkgs
    # slycot = [ slycot ];
    cvxopt = [ cvxopt ];
  };

  nativeCheckInputs = [
    numpydoc
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "control" ];

  disabledTestPaths = [
    # Don't test the docs
    "doc/test_sphinxdocs.py"
  ];

  meta = {
    description = "Python Control Systems Library";
    changelog = "https://github.com/python-control/python-control/releases/tag/${src.tag}";
    homepage = "https://github.com/python-control/python-control";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Peter3579 ];
  };
}
