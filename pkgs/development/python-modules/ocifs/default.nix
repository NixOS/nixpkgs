{ lib
, buildPythonPackage
, fetchFromGitHub
, fsspec
, oci
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ocifs";
  version = "1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-HY2LTm3JckAzNMVuAJNs/0LixBwiG/QKa7ILquY0Q+c=";
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
