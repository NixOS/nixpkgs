{ stdenv
, buildPythonPackage
, fetchPypi
, ipaddress
, python
, pythonOlder
}:

buildPythonPackage rec {
  version = "0.1.4";
  pname = "ifaddr";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "cf2a8fbb578da2844d999a0a453825f660ed2d3fc47dcffc5f673dd8de4f0f8b";
  };

  # ipaddress is provided in python stdlib > 3.3
  postPatch = if pythonOlder "3.4" then "" else ''
    sed -i "s/'ipaddress'//" setup.py
  '';

  propagatedBuildInputs = [ ipaddress ];

  checkPhase = ''
   ${python.interpreter} ifaddr/test_ifaddr.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pydron/ifaddr;
    description = "Enumerates all IP addresses on all network adapters of the system";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
