{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, python
}:

if (pythonAtLeast "3.3") then null else buildPythonPackage rec {
  pname = "ipaddress";
  version = "1.0.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2";
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
