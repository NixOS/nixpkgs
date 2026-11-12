{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  toml,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "scikit-base";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sktime";
    repo = "skbase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hA9CSsrCIN5wfudPsDy1P+dail4TPcmB2olzcBocZ88=";
  };

  build-system = [ setuptools ];

  dependencies = [ toml ];

  pythonImportsCheck = [ "skbase" ];

  meta = {
    description = "Base classes for creating scikit-learn-like parametric objects, and tools for working with them";
    homepage = "https://github.com/sktime/skbase";
    changelog = "https://github.com/sktime/skbase/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kirillrdy ];
  };
})
