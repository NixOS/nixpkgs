{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, python
}:

if (pythonAtLeast "3.3") then null else buildPythonPackage rec {
  pname = "ipaddress";
  version = "1.0.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b146c751ea45cad6188dd6cf2d9b757f6f4f8d6ffb96a023e6f2e26eea02a72c";
  };

  checkPhase = ''
    ${python.interpreter} test_ipaddress.py
  '';

  meta = with stdenv.lib; {
    description = "Port of the 3.3+ ipaddress module to 2.6, 2.7, and 3.2";
    homepage = https://github.com/phihag/ipaddress;
    license = licenses.psfl;
  };

}
