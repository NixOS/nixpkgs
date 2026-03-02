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
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neo4j";
    repo = "neo4j-python-driver";
    tag = finalAttrs.version;
    hash = "sha256-1Ef9SMJid0q+tI8hceriNu2vsLAyW4Jxt53ifcmi5VA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >=" \
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
