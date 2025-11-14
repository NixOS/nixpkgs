{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "reactivex";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ReactiveX";
    repo = "RxPY";
    tag = "v${version}";
    hash = "sha256-napPfp72gqy43UmkPu1/erhjmJbZypHZQikmjIFVBqA=";
  };

  build-system = [ poetry-core ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream doesn't set a version for their GitHub releases
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"'
  '';

  pythonImportsCheck = [ "reactivex" ];

  meta = {
    changelog = "https://github.com/ReactiveX/RxPY/releases/tag/${src.tag}";
    description = "Library for composing asynchronous and event-based programs";
    homepage = "https://github.com/ReactiveX/RxPY";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
