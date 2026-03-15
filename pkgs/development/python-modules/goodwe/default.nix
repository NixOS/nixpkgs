{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "goodwe";
  version = "0.4.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marcelblijleven";
    repo = "goodwe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WHLvfAlwhcA0JFSWfwUPsJ9dWmadIjyonXEP3Bb6WKE=";
  };

  patches = [
    (fetchpatch {
      name = "python-3.14.patch";
      url = "https://github.com/marcelblijleven/goodwe/commit/3a1e57109e61860f59a03626a7e21ee44bbb3639.patch";
      hash = "sha256-ZYmEdWpOjrU61HAyhNG04oTrSH8F+LUEUskxKkoufu4=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "goodwe" ];

  meta = {
    description = "Python library for connecting to GoodWe inverter";
    homepage = "https://github.com/marcelblijleven/goodwe";
    changelog = "https://github.com/marcelblijleven/goodwe/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
