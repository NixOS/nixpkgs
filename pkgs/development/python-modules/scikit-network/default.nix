{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  cython,
  setuptools,
  numpy,
  scipy,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "scikit-network";
  version = "0.33.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "scikit-network";
    hash = "sha256-9/fMAutCZ7Fqk4P2RiYVLlm6Q11td7GjVmW2/BvPVy0=";
  };

  # can be removed if https://github.com/sknetwork-team/scikit-network/pull/581 is merged
  # pytest-runner actually is not a setup requirement
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "__builtins__.__NUMPY_SETUP__ = False" "__builtins__['__NUMPY_SETUP__'] = False" \
      --replace-fail "setup_requirements = ['pytest-runner']" "setup_requirements = []"
  '';

  build-system = [
    cython
    setuptools
    numpy
    scipy
  ];

  dependencies = [
    numpy
    scipy
  ];

  # See https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd $out
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sknetwork" ];

  meta = {
    description = "Free software library in Python for machine learning on graphs";
    changelog = "https://github.com/sknetwork-team/scikit-network/blob/v${version}/HISTORY.rst";
    homepage = "https://scikit-network.readthedocs.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ simonbabovic ];
  };
}
