{ lib
, buildPythonPackage
, fetchFromGitHub
, fsspec
, oci
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ocifs";
  version = "1.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-wMKrK7ONc3M6beF9czrGddSeElCOTGh+JD9efb4Shbg=";
  };

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
    license = with licenses; [ upl ];
    maintainers = with maintainers; [ fab ];
  };
}
