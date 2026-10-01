{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  nix-update-script,
  owlrl,
  packaging,
  poetry-core,
  prettytable,
  pyduktape2,
  pyoxigraph,
  pytest-cov-stub,
  pytestCheckHook,
  rdflib,
  sanic-cors,
  sanic-ext,
  sanic,
  types-setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyshacl";
  version = "0.40.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rdflib";
    repo = "pyshacl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wShpDfxHAW057NnWZSo74QjJh8xXEVgZxPqrdqoX08w=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    importlib-metadata
    owlrl
    packaging
    prettytable
    rdflib
  ];

  optional-dependencies = {
    http = [
      sanic
      sanic-cors
      sanic-ext
    ];
    js = [ pyduktape2 ];
    oxigraph = [ pyoxigraph ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTests = [
    # Tests require network access
    "test_154"
    "test_cmdline_web"
    "test_cmdline_jsonld"
    "test_web_retrieve"
    "test_web_retrieve_fail"
    "test_owl_imports"
    "test_owl_imports_fail"
  ];

  pythonImportsCheck = [ "pyshacl" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python validator for SHACL";
    homepage = "https://github.com/rdflib/pyshacl";
    changelog = "https://github.com/rdflib/pyshacl/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
