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
  pytest-cov,
  pytestCheckHook,
  unasync,
}:

buildPythonPackage rec {
  pname = "postgrest";
  version = "2.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${version}";
    hash = "sha256-nK+IZRrKjNy84EC8krBvAZll5E0+jV3bLJh8qIVRElI=";
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

  # Upstream pins `uv_build>=0.8.3,<0.9.0`, but nixpkgs ships `uv-build` 0.9.x.
  # Relax the upper bound to accept the 0.9 series, consistent with uv’s documentation examples:
  # https://docs.astral.sh/uv/concepts/build-backend/#using-the-uv-build-backend
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-warn 'uv_build>=0.8.3,<0.9.0' 'uv_build>=0.8.3'
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov
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
    changelog = "https://github.com/supabase/supabase-py/blob/v${src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ jherland ];
    license = lib.licenses.mit;
  };
}
