{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, requests, zeroconf, netifaces, pytest }:

buildPythonPackage rec {
  pname = "netdisco";
  version = "2.0.0";

  disabled = !isPy3k;

  # PyPI is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = pname;
    rev = version;
    sha256 = "08x5ab7v6a20753y9br7pvfm6a054ywn7y7gh6fydqski0gad6l7";
  };

  propagatedBuildInputs = [ requests zeroconf netifaces ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Python library to scan local network for services and devices";
    homepage = https://github.com/home-assistant/netdisco;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
