{ buildOctavePackage
, lib
, fetchFromGitHub
}:

buildOctavePackage rec {
  pname = "fuzzy-logic-toolkit";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "lmarkowsky";
    repo = "fuzzy-logic-toolkit";
    rev = "refs/tags/${version}";
    sha256 = "sha256-veU+3DPFJ2IeGw5PkpxGO8Oo9qEyR890hs4IAzbfxls=";
  };

  meta = with lib; {
    homepage = "https://github.com/lmarkowsky/fuzzy-logic-toolkit";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Mostly MATLAB-compatible fuzzy logic toolkit for Octave";
  };
}
