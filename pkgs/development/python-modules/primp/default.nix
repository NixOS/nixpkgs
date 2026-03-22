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
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "primp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ahTIEStYQ5M7EYidQYpYEVbYwwFFRfBXErWOMDdgNnk=";
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
  disabledTestPaths = [ "crates/primp-python/tests/test_impersonate.py" ];

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
