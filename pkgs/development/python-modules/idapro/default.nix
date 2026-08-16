{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "idapro";
  version = "0.0.10";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-QXwDxGBdGEF+Rw9qdI45eznW1YKevTu97dkv9bkJLRE=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  # Module has no tests
  doCheck = false;

  # Requires IDE to be installed
  # pythonImportsCheck = [ "idapro" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "IDA Library Python module";
    homepage = "https://pypi.org/project/idapro";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
