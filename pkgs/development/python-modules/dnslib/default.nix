{
  lib,
  python,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dnslib";
  version = "0.9.25";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aH3yCG4oCGyzK5R9r6TApOYT8UKbqjvmHYuU5pQYtO8=";
  };

  checkPhase = ''
    VERSIONS=${python.interpreter} ./run_tests.sh
  '';

  pythonImportsCheck = [ "dnslib" ];

  meta = with lib; {
    description = "Simple library to encode/decode DNS wire-format packets";
    homepage = "https://github.com/paulc/dnslib";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
