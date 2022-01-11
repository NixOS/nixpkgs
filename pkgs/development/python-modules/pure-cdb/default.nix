{ lib, fetchFromGitHub, buildPythonPackage, pythonOlder, flake8 }:

buildPythonPackage rec {
  pname = "pure-cdb";
  version = "3.1.1";
  disabled = pythonOlder "3.4";

  # Archive on pypi has no tests.
  src = fetchFromGitHub {
    owner = "bbayles";
    repo = "python-pure-cdb";
    rev = "v${version}";
    hash = "sha256-/FAe4NkY5unt83BOnJ3QqBJFQCPdQnbMVl1fSZ511Fc=";
  };

  checkInputs = [ flake8 ];

  pythonImportsCheck = [ "cdblib" ];

  meta = with lib; {
    description = "Python library for working with constant databases";
    homepage = "https://python-pure-cdb.readthedocs.io/en/latest";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
