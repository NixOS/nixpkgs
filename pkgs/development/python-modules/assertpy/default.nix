{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "assertpy";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "assertpy";
    repo = "assertpy";
    tag = finalAttrs.version;
    hash = "sha256-TmDnwYvOQIpjwBpMCCn+qg68HnKc0qzVP9fjygqBzkI=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "assertpy" ];

  meta = {
    description = "Simple assertion library for unit testing with a fluent API";
    homepage = "https://github.com/assertpy/assertpy";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
