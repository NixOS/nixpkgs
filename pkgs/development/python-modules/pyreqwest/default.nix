{
  buildPythonPackage,
  cacert,
  dirty-equals,
  docker,
  fetchFromGitHub,
  granian,
  httpx,
  lib,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  requests-toolbelt,
  rustPlatform,
  starlette,
  syrupy,
  trustme,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyreqwest";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarkusSintonen";
    repo = "pyreqwest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o33/KkPBl4ActDV0R8KqWll6F47HPO3amHFI00rHryE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-+flEikEImbiu/x+pJQz3rynYKmfjaS9N0/A1HSzH0jU=";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "pyreqwest" ];

  nativeCheckInputs = [
    dirty-equals
    docker
    granian
    httpx
    pydantic
    pytest-asyncio
    pytestCheckHook
    requests-toolbelt
    starlette
    syrupy
    trustme
    yarl
  ];

  preCheck = ''
    # Without this tests fails with
    #     unexpected error: No CA certificates were loaded from the system
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';

  disabledTestPaths = [
    # requires a running Docker daemon
    "tests/test_examples.py"
  ];

  meta = {
    changelog = "https://github.com/MarkusSintonen/pyreqwest/releases/tag/${finalAttrs.src.tag}";
    description = "Fast Python HTTP client based on Rust reqwest";
    homepage = "https://github.com/MarkusSintonen/pyreqwest";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
