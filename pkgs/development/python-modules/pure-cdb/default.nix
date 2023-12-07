{ lib, fetchFromGitHub, buildPythonPackage, pythonOlder, flake8 }:

buildPythonPackage rec {
  pname = "pure-cdb";
  version = "4.0.0";
  format = "setuptools";
  disabled = pythonOlder "3.4";

  # Archive on pypi has no tests.
  src = fetchFromGitHub {
    owner = "bbayles";
    repo = "python-pure-cdb";
    rev = "refs/tags/v${version}";
    hash = "sha256-7zxQO+oTZJhXfM2yijGXchLixiQRuFTOSESVlEc+T0s=";
  };

  nativeCheckInputs = [ flake8 ];

  pythonImportsCheck = [ "cdblib" ];

  meta = with lib; {
    description = "Python library for working with constant databases";
    homepage = "https://python-pure-cdb.readthedocs.io/en/latest";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
