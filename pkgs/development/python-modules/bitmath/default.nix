{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, progressbar231 ? null, progressbar33, mock }:

buildPythonPackage rec {
  pname = "bitmath";
  version = "1.3.3.1";

  src = fetchFromGitHub {
     owner = "tbielawa";
     repo = "bitmath";
     rev = "1.3.3.1";
     sha256 = "1hln7rlvlmh7xs8axc9znf2hfdbsby7r0kzvwc39a3d8c7rxp81f";
  };

  checkInputs = [ (if isPy3k then progressbar33 else progressbar231) mock ];

  meta = with lib; {
    description = "Module for representing and manipulating file sizes with different prefix";
    homepage = "https://github.com/tbielawa/bitmath";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
