{ lib
, buildPythonPackage
, fetchFromGitHub
, mypy
, poetry-core
, pyasn1
, pytest-cov
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rsa";
  version = "4.9";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sybrenstuvel";
    repo = "python-rsa";
    rev = "version-${version}";
    hash = "sha256-PwaRe+ICy0UoguXSMSh3PFl5R+YAhJwNdNN9isadlJY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [ pyasn1 ];

  checkInputs = [
    mypy
    pytest-cov
    pytestCheckHook
  ];

  preConfigure = lib.optionalString (pythonOlder "3.7") ''
    substituteInPlace setup.py --replace "open('README.md')" "open('README.md',encoding='utf-8')"
  '';

  meta = with lib; {
    homepage = "https://stuvel.eu/rsa";
    license = licenses.asl20;
    description = "A pure-Python RSA implementation";
  };
}
