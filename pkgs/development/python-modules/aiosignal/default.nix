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

buildPythonPackage rec {
  pname = "aiosignal";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiosignal";
    tag = "v${version}";
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

  meta = with lib; {
    description = "Python list of registered asynchronous callbacks";
    homepage = "https://github.com/aio-libs/aiosignal";
    changelog = "https://github.com/aio-libs/aiosignal/blob/v${version}/CHANGES.rst";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
