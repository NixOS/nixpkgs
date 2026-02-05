{
  lib,
  buildPythonPackage,
  eval-type-backport,
  fetchPypi,
  uv-build,
  llama-index-instrumentation,
  pydantic,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-workflows";
  version = "2.13.1";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_workflows";
    inherit (finalAttrs) version;
    hash = "sha256-Vc08/5ySo3Jyq4ZRrXUCiKvDORZbAJBm8TDLDFxlmUs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.10,<0.10.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    eval-type-backport
    llama-index-instrumentation
    pydantic
  ];

  pythonImportsCheck = [ "workflows" ];

  meta = {
    description = "Event-driven, async-first, step-based way to control the execution flow of AI applications like Agents";
    homepage = "https://pypi.org/project/llama-index-workflows/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
