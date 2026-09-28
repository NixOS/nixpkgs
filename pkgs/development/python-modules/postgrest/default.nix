{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  uv-build,
  httpx,
  pydantic,
  yarl,
  strenum,
  deprecation,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  unasync,
}:

buildPythonPackage (finalAttrs: {
  pname = "postgrest";
  version = "2.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LaSlAYFvx/HHdfmc9J+KScVQ9JFGS98Yfihzn8F7t3g=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/postgrest";

  build-system = [ uv-build ];

  dependencies = [
    httpx
    deprecation
    pydantic
    strenum
    yarl
  ]
  ++ httpx.optional-dependencies.http2;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.8.3,<0.9.0' 'uv_build>=0.8.3'
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    unasync
  ];

  pythonImportsCheck = [ "postgrest" ];

  disabledTestPaths = [
    "tests/_sync/"
    "tests/_async/"
  ];

  meta = {
    description = "Client library for Supabase Functions";
    homepage = "https://github.com/supabase/supabase-py";
    changelog = "https://github.com/supabase/supabase-py/blob/v${finalAttrs.src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ macbucheron ];
    license = lib.licenses.mit;
  };
})
