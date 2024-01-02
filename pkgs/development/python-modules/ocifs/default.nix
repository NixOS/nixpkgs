{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, fsspec
, oci
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ocifs";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "ocifs";
    rev = "refs/tags/${version}";
    hash = "sha256-ugNITi2tSf3lhbASgr6ErmFDYinQjnhmtRjV3YL7F9U=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    fsspec
    oci
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ocifs"
  ];

  meta = with lib; {
    description = "Oracle Cloud Infrastructure Object Storage fsspec implementation";
    homepage = "https://ocifs.readthedocs.io";
    changelog = "https://github.com/oracle/ocifs/releases/tag/${version}";
    license = with licenses; [ upl ];
    maintainers = with maintainers; [ fab ];
  };
}
