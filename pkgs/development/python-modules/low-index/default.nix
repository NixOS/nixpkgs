{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "low-index";
  version = "1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "low_index";
    tag = "v${version}_as_released";
    hash = "sha256-m3p05bqu70pMOsb9drW1B6+N893eBSZBFTNNS23OY6w=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "low_index" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m low_index.test
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(.*)_as_released"
    ];
  };

  meta = {
    description = "Enumerates low index subgroups of a finitely presented group";
    changelog = "https://github.com/3-manifolds/low_index/releases/tag/${src.tag}";
    homepage = "https://github.com/3-manifolds/low_index";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
}
