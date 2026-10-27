{
  buildPythonPackage,
  click,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aio-ownet";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "aio-ownet";
    tag = "v${version}";
    hash = "sha256-KgQasltfoffVjCDX9s98qnZrv+VLiEffLi9FnUD5vXc=";
  };

  build-system = [ poetry-core ];

  optional-dependencies = {
    cli = [ click ];
  };

  pythonImportsCheck = [ "aio_ownet" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/hacf-fr/aio-ownet/releases/tag/${src.tag}";
    description = "Asynchronous OWFS (owserver network protocol) client library";
    homepage = "https://github.com/hacf-fr/aio-ownet";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
