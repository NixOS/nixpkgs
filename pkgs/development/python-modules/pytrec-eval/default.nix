{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  # Build system
  setuptools,
  # Dependencies
  numpy,
  scipy,
  # Tests
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytrec-eval";
  version = "0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cvangysel";
    repo = "pytrec_eval";
    tag = finalAttrs.version;
    hash = "sha256-t76D3C5QMJgQMhAg8TGxdtjwaLQhlB8SufAdM3pAZg4=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
  ];

  # trec_eval which is included in source code requres older C standard
  CFLAGS = "-std=gnu89";

  dependencies = [
    numpy
    scipy
  ];

  # Tests
  nativeCheckInputs = [ unittestCheckHook ];
  pythonImportsCheck = [
    "pytrec_eval"
  ];
  unittestFlags = "-s tests -p *test* -v";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pytrec_eval is an Information Retrieval evaluation tool for Python, based on the popular trec_eval";
    homepage = "https://github.com/cvangysel/pytrec_eval";
    changelog = "https://github.com/cvangysel/pytrec_eval/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ LodWKobku ];
  };
})
