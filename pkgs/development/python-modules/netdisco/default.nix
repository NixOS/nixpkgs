{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, fetchpatch, requests, zeroconf, netifaces, pytest }:

buildPythonPackage rec {
  pname = "netdisco";
  version = "1.3.1";

  disabled = !isPy3k;

  # PyPI is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = pname;
    rev = version;
    sha256 = "082ihazpcmf7qh4671kgdr5kzglyj10gp9hyy52snh0c1rz468fd";
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
