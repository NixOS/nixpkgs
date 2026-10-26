{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "prison";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "betodealmeida";
    repo = "python-rison";
    rev = finalAttrs.version;
    hash = "sha256-qor40vUQeTdlO3vwug3GGNX5vkNaF0H7EWlRdsY4bvc=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Rison encoder/decoder";
    homepage = "https://github.com/betodealmeida/python-rison";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
