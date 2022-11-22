{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, k5test
, pkgs
, pytestCheckHook
, pythonOlder
, which
}:

buildPythonPackage rec {
  pname = "krb5";
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "pykrb5";
    rev = "refs/tags/v${version}";
    hash = "sha256-aifu99CDT/RtDmqIK3SAQATDCvbR9FvwRR2L3hYG0gs=";
  };

  nativeBuildInputs = [
    cython
    pkgs.krb5
  ];

  checkInputs = [
    pytestCheckHook
    k5test
    which
  ];

  pythonImportsCheck = [
    "krb5"
  ];

  meta = with lib; {
    description = "Kerberos API for Python";
    homepage    = "https://github.com/jborean93/pykrb5";
    changelog = "https://github.com/jborean93/pykrb5/releases/tag/v${version}";
    license     = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
