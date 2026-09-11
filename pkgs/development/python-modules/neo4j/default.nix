{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pandas,
  pyarrow,
  pytz,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "neo4j";
  version = "6.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neo4j";
    repo = "neo4j-python-driver";
    tag = finalAttrs.version;
    hash = "sha256-9ehfq8CuhaSMmDz9o/2litchyg18CfXNpQRZpikLMXg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools == 84.0.0" "setuptools" \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [ pytz ];

  optional-dependencies = {
    numpy = [ numpy ];
    pandas = [
      numpy
      pandas
    ];
    pyarrow = [ pyarrow ];
  };

  # Missing dependencies
  doCheck = false;

  pythonImportsCheck = [ "neo4j" ];

  meta = {
    description = "Neo4j Bolt Driver for Python";
    homepage = "https://github.com/neo4j/neo4j-python-driver";
    changelog = "https://github.com/neo4j/neo4j-python-driver/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
