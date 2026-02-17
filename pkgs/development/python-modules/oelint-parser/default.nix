{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  deprecated,
  regex,
  pytest-cov-stub,
  pytest-forked,
  pytest-random-order,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "oelint-parser";
  version = "8.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "priv-kweihmann";
    repo = "oelint-parser";
    tag = finalAttrs.version;
    hash = "sha256-r2MleUgfElyUyq/lEoOOJqdxlTkmY1zlgi2RcW70LzI=";
  };

  pythonRelaxDeps = [ "regex" ];

  build-system = [ setuptools ];

  dependencies = [
    regex
    deprecated
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-forked
    pytest-random-order
    pytestCheckHook
  ];

  pythonImportsCheck = [ "oelint_parser" ];

  meta = {
    description = "Alternative parser for bitbake recipes";
    homepage = "https://github.com/priv-kweihmann/oelint-parser";
    changelog = "https://github.com/priv-kweihmann/oelint-parser/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ otavio ];
  };
})
