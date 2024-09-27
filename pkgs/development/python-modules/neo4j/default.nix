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
  tomlkit,
}:

buildPythonPackage rec {
  pname = "neo4j";
  version = "5.25.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "neo4j";
    repo = "neo4j-python-driver";
    rev = "refs/tags/${version}";
    hash = "sha256-aGUfyfN85JNOQSnnM+zep07cmLqq9YN1bc7UyH3uFWg=";
  };

  postPatch = ''
    # The dynamic versioning adds a postfix (.dev0) to the version
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >=" \
      --replace-fail "tomlkit ==" "tomlkit >=" \
      --replace-fail 'dynamic = ["version", "readme"]' 'dynamic = ["readme"]' \
      --replace-fail '#readme = "README.rst"' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    pytz
    tomlkit
  ];

  passthru.optional-dependencies = {
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
    changelog = "https://github.com/neo4j/neo4j-python-driver/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
