{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

# This package provides a binary "apython" which sometimes invokes
# [sys.executable, '-m', 'aioconsole'] as a subprocess. If apython is
# run directly out of this derivation, it won't work, because
# sys.executable will point to a Python binary that is not wrapped to
# be able to find aioconsole.
# However, apython will work fine when using python##.withPackages,
# because with python##.withPackages the sys.executable is already
# wrapped to be able to find aioconsole and any other packages.
buildPythonPackage rec {
  pname = "aioconsole";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vxgmichel";
    repo = "aioconsole";
    tag = "v${version}";
    hash = "sha256-j4nzt8mvn+AYObh1lvgxS8wWK662KN+OxjJ2b5ZNAcQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --strict-markers --count 2 -vv" ""
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    "test_interact_syntax_error"
    # Output and the sandbox don't work well together
    "test_interact_multiple_indented_lines"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # OSError: AF_UNIX path too long
    "tests/test_server.py::test_uds_server[default]"
  ];

  pythonImportsCheck = [ "aioconsole" ];

  meta = {
    description = "Asynchronous console and interfaces for asyncio";
    changelog = "https://github.com/vxgmichel/aioconsole/releases/tag/v${version}";
    homepage = "https://github.com/vxgmichel/aioconsole";
    license = lib.licenses.gpl3Only;
    mainProgram = "apython";
  };
}
