{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  pytestCheckHook,
  pydantic,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "lazy-model";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BeanieODM";
    repo = "lazy_model";
    tag = "v${version}";
    hash = "sha256-9ap/iKw7miRo8ZEb5qWCHuRQfOm+HUdu93nzi6P6Eow=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Lazy parsing for Pydantic models";
    maintainers = with lib.maintainers;[ bot-wxt1221 ];
    homepage = "https://pypi.org/project/lazy-model/#description";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
  };
}
