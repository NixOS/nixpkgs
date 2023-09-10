{ lib
, buildPythonPackage
, colorama
, fetchFromGitHub
, packaging
, poetry-core
, pydantic
, redis
, structlog
}:

buildPythonPackage rec {
  pname = "diffsync";
  version = "1.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = "diffsync";
    rev = "refs/tags/v${version}";
    hash = "sha256-2OhckgJK1qimF0AcYSa8L+AkzfiN5VojWj0x6kwbgyk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    colorama
    packaging
    pydantic
    redis
    structlog
  ];

  pythonImportsCheck = [
    "diffsync"
  ];

  meta = with lib; {
    description = "Utility library for comparing and synchronizing different datasets";
    homepage = "https://github.com/networktocode/diffsync";
    changelog = "https://github.com/networktocode/diffsync/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ clerie ];
  };
}
