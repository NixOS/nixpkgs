{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "primp";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "primp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W5wjsuehTIdrImBVkmcEptiEE0CtlHJZ0kAbP3f3TTg=";
  };

  # The Cargo.lock is not pushed upstream
  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  buildAndTestSubdir = "crates/primp-python";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];
  # pytest runs from the source root but asyncio_mode=auto is configured in
  # crates/primp-python/pyproject.toml, which pytest doesn't pick up from there
  pytestFlags = [
    "-o"
    "asyncio_mode=auto"
  ];

  disabledTestPaths = [
    "crates/primp-python/tests/test_impersonate.py"
    "crates/primp-python/tests/test_header_order.py"
  ];

  # Tests crash with Abort trap: 6 on Darwin due to tokio runtime
  # initialization in PyInit_pyo3_async_runtimes being blocked by the sandbox.
  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [ "primp" ];

  meta = {
    changelog = "https://github.com/deedy5/primp/releases/tag/${finalAttrs.src.tag}";
    description = " HTTP client that can impersonate web browsers";
    homepage = "https://github.com/deedy5/primp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drawbu ];
  };
})
