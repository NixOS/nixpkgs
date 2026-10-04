{
  buildPythonPackage,
  cattrs,
  fetchFromGitHub,
  lib,
  lxml,
  markdown,
  orjson,
  pathspec,
  pymdown-extensions,
  pytestCheckHook,
  pyyaml,
  requests,
  setuptools,
  truststore,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "markdown-to-confluence";
  version = "0.6.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hunyadi";
    repo = "md2conf";
    tag = finalAttrs.version;
    hash = "sha256-+jbCJKOivJWuxfgLT7sUEJWunfG2S0i6qaC04MQojik=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cattrs
    lxml
    markdown
    orjson
    pathspec
    pymdown-extensions
    pyyaml
    requests
    truststore
  ];

  pythonRelaxDeps = [
    "cattrs"
    "orjson"
    "pymdown-extensions"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];

  disabledTestPaths = [
    # Requires credentials and a live Confluence instance.
    "integration_tests"
  ];

  pythonImportsCheck = [ "md2conf" ];

  meta = {
    description = "Publish Markdown files to Confluence wiki";
    homepage = "https://github.com/hunyadi/md2conf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ attila ];
    mainProgram = "md2conf";
  };
})
