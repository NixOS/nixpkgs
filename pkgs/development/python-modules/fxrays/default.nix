{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
}:

buildPythonPackage rec {
  pname = "fxrays";
  version = "1.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "FXrays";
    tag = "${version}_as_released";
    hash = "sha256-IwEY54zDXqMci7WRvhueDJidTsbMwv6eqQSGZzFOtnQ";
  };

  build-system = [
    setuptools
    cython
  ];

  pythonImportsCheck = [ "FXrays" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m FXrays.test
    runHook postCheck
  '';

  meta = {
    description = "Computes extremal rays of polyhedral cones with filtering";
    changelog = "https://github.com/3-manifolds/FXrays/releases/tag/${src.tag}";
    homepage = "https://github.com/3-manifolds/FXrays";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ noiioiu ];
  };
}
