{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bnunicodenormalizer";
  version = "0.1.7";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-hqNInMgcc9KvtOJlvS0Ni8UvyKI3TiEMiZ4CYJQLwJE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bnunicodenormalizer" ];

  meta = {
    description = "Bangla Unicode Normalization Toolkit";
    homepage = "https://github.com/mnansary/bnUnicodeNormalizer";
    license = lib.licenses.mit;
    teams = [ lib.teams.tts ];
  };
})
