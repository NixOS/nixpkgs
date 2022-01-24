{ lib
, buildPythonPackage
, fetchPypi
, ipaddress
, python
}:

buildPythonPackage rec {
  version = "0.1.7";
  pname = "ifaddr";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f9e8a6ca6f16db5a37d3356f07b6e52344f6f9f7e806d618537731669eb1a94";
  };

  propagatedBuildInputs = [ ipaddress ];

  checkPhase = ''
   ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    homepage = "https://github.com/pydron/ifaddr";
    description = "Enumerates all IP addresses on all network adapters of the system";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
