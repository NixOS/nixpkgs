{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytest,
  schema,
  typeguard,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-revealtype-injector";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_revealtype_injector";
    inherit (finalAttrs) version;
    hash = "sha256-+KuSByu92K7bkdaTmef6qrjhzUvCKcuqL7O1cfubKuQ=";
  };

  build-system = [ hatchling ];

  buildInput = [ pytest ];

  dependencies = [
    pytest
    schema
    typeguard
    typing-extensions
  ];

  # Upstream tests require external type checker binaries (mypy/pyright/pyrefly/ty)
  # that are not propagated by this plugin.
  doCheck = false;

  pythonImportsCheck = [ "pytest_revealtype_injector" ];

  meta = {
    description = "Pytest plugin for replacing reveal_type calls with static and runtime checks";
    homepage = "https://github.com/abelcheung/pytest-revealtype-injector";
    changelog = "https://github.com/abelcheung/pytest-revealtype-injector/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ attila ];
  };
})
