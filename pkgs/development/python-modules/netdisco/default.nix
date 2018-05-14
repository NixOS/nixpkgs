{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, fetchpatch, requests, zeroconf, netifaces, pytest }:

buildPythonPackage rec {
  pname = "netdisco";
  version = "1.4.0";

  disabled = !isPy3k;

  # PyPI is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = pname;
    rev = version;
    sha256 = "0q1cl76a0fwxm80lkk7cpd4p23r2bvf1a45nb7n61cgzrqcv43q1";
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
