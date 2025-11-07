{
  lib,
  isPy27,
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
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "gkhayes";
    repo = "mlrose";
    rev = "v${version}";
    sha256 = "1dn43k3rcypj58ymcj849b37w66jz7fphw8842v6mlbij3x0rxfl";
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

  meta = with lib; {
    description = "Machine Learning, Randomized Optimization and SEarch";
    homepage = "https://github.com/gkhayes/mlrose";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
