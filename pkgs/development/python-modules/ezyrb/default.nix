{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  future,
  numpy,
  scipy,
  matplotlib,
  scikit-learn,
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ezyrb";
  version = "1.3.0.post2404";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mathLab";
    repo = "EZyRB";
    tag = "v${version}";
    hash = "sha256-nu75Geyeu1nTLoGaohXB9pmbUWKgdgch9Z5OJqz9xKQ=";
  };

  # AttributeError: module 'numpy' has no attribute 'VisibleDeprecationWarning'
  postPatch = ''
    substituteInPlace \
      tests/test_k_neighbors_regressor.py \
      tests/test_linear.py \
      tests/test_radius_neighbors_regressor.py \
      --replace-fail \
        "np.VisibleDeprecationWarning" \
        "np.exceptions.VisibleDeprecationWarning"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    future
    matplotlib
    numpy
    scikit-learn
    scipy
    torch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ezyrb" ];

  disabledTestPaths = [
    # Exclude long tests
    "tests/test_podae.py"
  ];

  meta = {
    description = "Easy Reduced Basis method";
    homepage = "https://mathlab.github.io/EZyRB/";
    downloadPage = "https://github.com/mathLab/EZyRB/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
