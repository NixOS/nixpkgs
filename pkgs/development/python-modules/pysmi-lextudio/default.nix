{ lib
, buildPythonPackage
, fetchFromGitHub
, ply
, poetry-core
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pysmi-lextudio";
  version = "1.1.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lextudio";
    repo = "pysmi";
    rev = "refs/tags/v${version}";
    hash = "sha256-P1uu1+EcqA7K+oJWFyHTyQqUvqZjZTU0owLKoxjaQhc=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    ply
    requests
  ];

  # Circular dependency on pysnmp-lextudio
  doCheck = false;

  pythonImportsCheck = [
    "pysmi"
  ];

  meta = with lib; {
    description = "SNMP MIB parser";
    homepage = "https://github.com/lextudio/pysmi";
    changelog = "https://github.com/lextudio/pysmi/blob/${version}/CHANGES.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
