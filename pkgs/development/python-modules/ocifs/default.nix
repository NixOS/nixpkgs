{ lib
, buildPythonPackage
, fetchFromGitHub
, fsspec
, oci
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ocifs";
  version = "1.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-zZREWEFWQj4G2RyEMH0X3oPr5Yu5/96UX6nm9HDmJCY=";
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
