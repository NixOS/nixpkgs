{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  duckdb,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "logica";
  version = "1.3.1415926535897";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-d5G/juvEOoBupWTneeKt85sPfZIyYYiFIywjwKCroaM=";
  };

  # setup.py reads the long description from a README the sdist does not ship.
  postPatch = ''
    touch logica/README.md
  '';

  build-system = [ setuptools ];

  dependencies = [ duckdb ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Upstream's golden-comparison suite (run_all_tests.py) needs the .l sources
  # and goldens, which the sdist omits, so only the unit tests can run. They
  # import relative to the package root, e.g. "from common import platonic".
  preCheck = ''
    cd logica
  '';

  enabledTestPaths = [
    "common/platonic_test.py"
    "type_inference/research/meta_types_test.py"
    "type_inference/tests"
  ];

  disabledTestPaths = [
    # Needs sqlalchemy and a live PostgreSQL server
    "type_inference/tests/db_interaction_test.py"
    # Stale: asserts an edge set that the builder no longer produces. Not part
    # of upstream's own suite, which never imports type_inference/tests.
    "type_inference/tests/types_graph_building_test.py"
  ];

  disabledTests = [
    # Same staleness as types_graph_building_test.py: the graph these build
    # comes back empty.
    "test_one_of_arguments_any"
    "test_three_predicates"
  ];

  pythonImportsCheck = [ "logica" ];

  meta = {
    description = "Declarative logic programming language for data manipulation";
    homepage = "https://logica.dev/";
    downloadPage = "https://github.com/evgskv/logica";
    license = [ lib.licenses.asl20 ];
    mainProgram = "logica";
    maintainers = [ lib.maintainers.rskew ];
  };
})
