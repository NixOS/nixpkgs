{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  pydantic,
  pytestCheckHook,
  django,
  fastapi,
  flask,
  httpx,
}:

buildPythonPackage (finalAttrs: {
  pname = "scim2-models";
  version = "0.6.12";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-scim";
    repo = "scim2-models";
    tag = finalAttrs.version;
    hash = "sha256-EYWPz44cVbff/qV/nSwU+RDWhLypUMoCAdZfxpkC9ag=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.9,<0.9.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ pydantic ] ++ pydantic.optional-dependencies.email;

  nativeCheckInputs = [
    pytestCheckHook
    django
    fastapi
    flask
    httpx
  ];

  pythonImportsCheck = [ "scim2_models" ];

  meta = {
    description = "SCIM2 models serialization and validation with pydantic";
    homepage = "https://github.com/python-scim/scim2-models";
    changelog = "https://github.com/python-scim/scim2-models/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
