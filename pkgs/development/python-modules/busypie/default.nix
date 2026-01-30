{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "busypie";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rockem";
    repo = "busypie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LaPgK36ieHKAbm9btx6t//dMdSGdzcaDJVou96D6J3U=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "busypie" ];

  meta = {
    description = "Expressive busy wait for Python";
    homepage = "https://github.com/rockem/busypie";
    changelog = "https://github.com/rockem/busypie/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
