{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pandas,
  pyarrow,
  pythonOlder,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "neo4j";
  version = "6.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neo4j";
    repo = "neo4j-python-driver";
    tag = version;
    hash = "sha256-0Idfa7hFrLSD26PpA/lJcVtYpAPcX+AF3wab092Sbzw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >=" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
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

  meta = with lib; {
    description = "Neo4j Bolt Driver for Python";
    homepage = "https://github.com/neo4j/neo4j-python-driver";
    changelog = "https://github.com/neo4j/neo4j-python-driver/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
