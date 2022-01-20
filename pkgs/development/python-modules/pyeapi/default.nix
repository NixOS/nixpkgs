{ lib, buildPythonPackage, fetchFromGitHub, netaddr, pytestCheckHook, coverage
, mock }:

buildPythonPackage rec {
  pname = "pyeapi";
  version = "0.8.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "arista-eosplus";
    repo = pname;
    rev = "v${version}";
    sha256 = "13chya6wix5jb82k67gr44bjx35gcdwz80nsvpv0gvzs6shn4d7b";
  };

  propagatedBuildInputs = [ netaddr ];

  checkInputs = [ coverage mock ];
  checkPhase = ''
    make unittest
  '';

  meta = with lib; {
    description = "Client for Arista eAPI";
    homepage = "https://github.com/arista-eosplus/pyeapi";
    license = licenses.bsd3;
    maintainers = [ maintainers.astro ];
  };
}
