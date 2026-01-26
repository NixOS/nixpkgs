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
  version = "8.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "priv-kweihmann";
    repo = "oelint-parser";
    tag = finalAttrs.version;
    hash = "sha256-F17THZo8fXoFP4b2DJnDjbZfT5xUX9+MMSxBa9sIy5c=";
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
