{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pandas
, pyarrow
, pythonOlder
, pytz
, setuptools
, tomlkit
}:

buildPythonPackage rec {
  pname = "neo4j";
  version = "5.16.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "neo4j";
    repo = "neo4j-python-driver";
    rev = "refs/tags/${version}";
    hash = "sha256-ly/R2ufd5gEkUyfajpeMQblTiKipC9HFtxkWkh16zLo=";
  };

  postPatch = ''
    # The dynamic versioning adds a postfix (.dev0) to the version
    substituteInPlace pyproject.toml \
      --replace '"tomlkit ~= 0.11.6"' '"tomlkit >= 0.11.6"' \
      --replace 'dynamic = ["version", "readme"]' 'dynamic = ["readme"]' \
      --replace '#readme = "README.rst"' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pytz
    tomlkit
  ];

  passthru.optional-dependencies = {
    numpy = [
      numpy
    ];
    pandas = [
      numpy
      pandas
    ];
    pyarrow = [
      pyarrow
    ];
  };

  # Missing dependencies
  doCheck = false;

  pythonImportsCheck = [
    "neo4j"
  ];

  meta = with lib; {
    description = "Neo4j Bolt Driver for Python";
    homepage = "https://github.com/neo4j/neo4j-python-driver";
    changelog = "https://github.com/neo4j/neo4j-python-driver/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
