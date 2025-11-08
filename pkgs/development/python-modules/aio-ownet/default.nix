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
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "aio-ownet";
    tag = "v${version}";
    hash = "sha256-XaulcBrFLu8YsfaYQsZfUBHnw0H5qX6itdgsiW89Ca4=";
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
