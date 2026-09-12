{
  lib,
  buildPythonPackage,
  fetchPypi,
  graphql-core,
  hatchling,
  hypothesis,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hypothesis-graphql";
  version = "0.12.0";
  pyproject = true;

  src = fetchPypi {
    pname = "hypothesis_graphql";
    inherit (finalAttrs) version;
    hash = "sha256-FfX2m24LmtiJ9Z00DgkdfUgUcTc+tqioWR0SaqVudwA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    graphql-core
    hypothesis
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  enabledTestPaths = [ "test/" ];

  disabledTestPaths = [
    # Corpus-based property tests over ~100 schemas are very slow
    "test/test_corpus.py"
  ];

  pythonImportsCheck = [ "hypothesis_graphql" ];

  meta = {
    description = "Hypothesis strategies for GraphQL queries";
    homepage = "https://github.com/Stranger6667/hypothesis-graphql";
    changelog = "https://github.com/Stranger6667/hypothesis-graphql/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tembleking ];
  };
})
