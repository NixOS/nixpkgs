{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  frozenlist,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiosignal";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiosignal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b46/LGoCeL4mhbBPAiPir7otzKKrlKcEFzn8pG/foh0=";
  };

  build-system = [ setuptools ];

  dependencies = [ frozenlist ] ++ lib.optionals (pythonOlder "3.13") [ typing-extensions ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "filterwarnings = error" ""
  '';

  pythonImportsCheck = [ "aiosignal" ];

  meta = {
    description = "Python list of registered asynchronous callbacks";
    homepage = "https://github.com/aio-libs/aiosignal";
    changelog = "https://github.com/aio-libs/aiosignal/blob/v${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
