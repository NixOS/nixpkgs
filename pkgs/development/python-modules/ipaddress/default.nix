{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, python
}:

if (pythonAtLeast "3.3") then null else buildPythonPackage rec {
  pname = "ipaddress";
  version = "1.0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q8klj9d84cmxgz66073x1j35cplr3r77vx1znhxiwl5w74391ax";
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
