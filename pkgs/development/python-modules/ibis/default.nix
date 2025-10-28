{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ibis";
  version = "3.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dmulholl";
    repo = "ibis";
    rev = version;
    hash = "sha256-9ELOAQhD6KXyTN2U0lGmNxxSzx9o2QIt+CNa6i8o5xs=";
  };

  checkPhase = ''
    ${python.interpreter} test_ibis.py
  '';

  pythonImportsCheck = [ "ibis" ];

  meta = with lib; {
    description = "Lightweight template engine";
    homepage = "https://github.com/dmulholland/ibis";
    license = licenses.publicDomain;
    maintainers = [ ];
  };
}
