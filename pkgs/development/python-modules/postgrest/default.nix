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

buildPythonPackage rec {
  pname = "postgrest";
  version = "2.28.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${version}";
    hash = "sha256-Ra7Ig9IMWouMIadx6mg/pe8GlgLCavR6OsPjqgySTCw=";
  };

  sourceRoot = "${src.name}/src/postgrest";

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
    changelog = "https://github.com/supabase/supabase-py/blob/${src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ macbucheron ];
    license = lib.licenses.mit;
  };
}
