{
  lib,
  buildPythonPackage,
  litellm,
  uv-build,
  psycopg,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "litellm-proxy-extras";
  version = "0.4.108";
  pyproject = true;

  inherit (litellm) src;

  sourceRoot = "${finalAttrs.src.name}/litellm-proxy-extras";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build==0.11.8" "uv_build"

    # prebuilt wheels committed upstream
    rm -r dist
  '';

  build-system = [ uv-build ];

  dependencies = [ psycopg ];

  pythonRemoveDeps = [ "psycopg-binary" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "litellm_proxy_extras" ];

  meta = {
    description = "Database migrations and Prisma tooling for the LiteLLM proxy";
    homepage = "https://github.com/BerriAI/litellm/tree/main/litellm-proxy-extras";
    license = lib.licenses.mit;
    inherit (litellm.meta) maintainers;
  };
})
