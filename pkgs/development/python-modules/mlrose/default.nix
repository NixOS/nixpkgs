{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  scikit-learn,
  pytestCheckHook,
  pytest-randomly,
}:

buildPythonPackage rec {
  pname = "mlrose";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gkhayes";
    repo = "mlrose";
    rev = "v${version}";
    hash = "sha256-1PUM+pBx0Wq2IAhxeN350hh+xkoESVY9KvJ6lsccxLY=";
  };

  patches = [
    # Fixes compatibility with scikit-learn 0.24.1
    (fetchpatch {
      url = "https://github.com/gkhayes/mlrose/pull/55/commits/19caf8616fc194402678aa67917db334ad02852a.patch";
      sha256 = "1nivz3bn21nd21bxbcl16a6jmy7y5j8ilz90cjmd0xq4v7flsahf";
    })
  ];

  build-system = [ setuptools ];
  dependencies = [ scikit-learn ];
  nativeCheckInputs = [
    pytest-randomly
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py --replace-fail sklearn scikit-learn
  '';

  pythonImportsCheck = [ "mlrose" ];

  # Fix random seed during tests
  pytestFlags = [ "--randomly-seed=0" ];

  disabledTests = [
    # mimic optimizer fails to converge under current numpy
    "test_mimic_discrete_max_fast"
  ];

  meta = {
    description = "Machine Learning, Randomized Optimization and SEarch";
    homepage = "https://github.com/gkhayes/mlrose";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
