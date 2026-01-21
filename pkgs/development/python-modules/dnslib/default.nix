{
  lib,
  python,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "dnslib";
  version = "0.9.26";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vlaFdTQ5Cy+9ApNScAGbrMXmtBHRVss5IaxVp/tR8ag=";
  };

  checkPhase = ''
    VERSIONS=${python.interpreter} ./run_tests.sh
  '';

  pythonImportsCheck = [ "dnslib" ];

  meta = {
    description = "Simple library to encode/decode DNS wire-format packets";
    homepage = "https://github.com/paulc/dnslib";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
