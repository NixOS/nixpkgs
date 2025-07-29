{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
}:

buildPythonPackage rec {
  pname = "knot-floer-homology";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "knot_floer_homology";
    tag = "${version}_as_released";
    hash = "sha256-Gw9k9AaUVTBzE+ERUH8VgS//aVT03DdKozpL8xLG4No=";
  };

  build-system = [
    setuptools
    cython
  ];

  pythonImportsCheck = [ "knot_floer_homology" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m knot_floer_homology.test
    runHook postCheck
  '';

  meta = {
    description = "Python wrapper for Zoltán Szabó's HFK Calculator";
    changelog = "https://github.com/3-manifolds/knot_floer_homology/releases/tag/${src.tag}";
    homepage = "https://github.com/3-manifolds/knot_floer_homology";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ noiioiu ];
  };
}
