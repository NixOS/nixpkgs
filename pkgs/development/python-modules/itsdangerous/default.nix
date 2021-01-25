{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "itsdangerous";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19";
  };

  meta = with lib; {
    description = "Helpers to pass trusted data to untrusted environments and back";
    homepage = "https://pypi.python.org/pypi/itsdangerous/";
    license = licenses.bsd0;
  };

}
