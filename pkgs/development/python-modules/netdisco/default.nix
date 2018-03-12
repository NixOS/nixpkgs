{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, requests, zeroconf, netifaces, pytest }:

buildPythonPackage rec {
  pname = "netdisco";
  version = "1.2.4";

  disabled = !isPy3k;

  # PyPI is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = pname;
    rev = version;
    sha256 = "170s9py8rw07cfgwvv7mf69g8jjg32m2rgw8x3kbvjqlmrdijxmm";
  };

  propagatedBuildInputs = [ requests zeroconf netifaces ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Python library to scan local network for services and devices";
    homepage = https://github.com/home-assistant/netdisco/;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
