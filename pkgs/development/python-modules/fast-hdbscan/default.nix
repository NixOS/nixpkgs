{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  numba,
  numpy,
  pynndescent,
  pytestCheckHook,
  scikit-learn,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fast-hdbscan";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TutteInstitute";
    repo = "fast_hdbscan";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-c+ZUTeckWsCsGNYQmrhFZxoIIbjgkIT5eQG78leUZ1A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numba
    numpy
    scikit-learn
  ];

  optional-dependencies = {
    nndescent = [ pynndescent ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  preCheck = ''
    export NUMBA_CACHE_DIR=$(mktemp -d)
  '';

  pythonImportsCheck = [ "fast_hdbscan" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-core implementation of HDBSCAN for low dimensional Euclidean spaces";
    homepage = "https://github.com/TutteInstitute/fast_hdbscan";
    changelog = "https://github.com/TutteInstitute/fast_hdbscan/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
