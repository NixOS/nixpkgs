{ lib, buildPythonPackage, fetchFromGitHub
, pytest, pytest-benchmark, pytest-mock }:

buildPythonPackage rec {
  pname = "getmac";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "GhostofGoes";
    repo = "getmac";
    rev = version;
    sha256 = "08d4iv5bjl1s4i9qhzf3pzjgj1rgbwi0x26qypf3ycgdj0a6gvh2";
  };

  checkInputs = [ pytest pytest-benchmark pytest-mock ];
  checkPhase = ''
    pytest --ignore tests/test_cli.py
  '';

  meta = with lib; {
    homepage = "https://github.com/GhostofGoes/getmac";
    description = "Pure-Python package to get the MAC address of network interfaces and hosts on the local network.";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
