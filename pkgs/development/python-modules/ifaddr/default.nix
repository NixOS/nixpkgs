{ stdenv
, buildPythonPackage
, fetchPypi
, ipaddress
, python
, pythonOlder
}:

buildPythonPackage rec {
  version = "0.1.6";
  pname = "ifaddr";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c19c64882a7ad51a394451dabcbbed72e98b5625ec1e79789924d5ea3e3ecb93";
  };

  propagatedBuildInputs = [ ipaddress ];

  checkPhase = ''
   ${python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pydron/ifaddr;
    description = "Enumerates all IP addresses on all network adapters of the system";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
