{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "reactivex";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ReactiveX";
    repo = "RxPY";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wgUbZsHIqBSXVnFjYFosoj1FptAwHz3Lqz+rlAG/Zw4=";
  };

  build-system = [ hatchling ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "reactivex" ];

  meta = {
    description = "Library for composing asynchronous and event-based programs";
    homepage = "https://github.com/ReactiveX/RxPY";
    changelog = "https://github.com/ReactiveX/RxPY/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
