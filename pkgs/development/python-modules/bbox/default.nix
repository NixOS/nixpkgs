{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  matplotlib,
  numpy,
  pendulum,
  pillow,
  poetry-core,
  pyquaternion,
  loguru,
  hatchling,
}:

buildPythonPackage {
  pname = "bbox";
  version = "0.9.4-unstable-2025-10-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "varunagrawal";
    repo = "bbox";
    rev = "ac3bc3036415337722dcaf46ab59f83b38d19828";
    hash = "sha256-IikvXxIhuZRkODMEiGUsu16GKiwfe62NxE5hOf5OfWk=";
  };

  nativeBuildInputs = [ poetry-core ];

  postPatch = ''
    substituteInPlace bbox/metrics.py \
      --replace-warn round_ round
  '';

  build-system = [
    hatchling
  ];

  propagatedBuildInputs = [
    pyquaternion
    numpy
    loguru
  ];

  nativeCheckInputs = [
    matplotlib
    pendulum
    pillow
    pytestCheckHook
  ];

  disabledTests = [
    # performance test, racy on busy machines
    "test_multi_jaccard_index_2d_performance"
  ];

  pythonRelaxDeps = [ "numpy" ];

  pythonImportsCheck = [ "bbox" ];

  meta = {
    description = "Python library for 2D/3D bounding boxes";
    homepage = "https://github.com/varunagrawal/bbox";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
