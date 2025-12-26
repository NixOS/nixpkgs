{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
}:

buildOctavePackage rec {
  pname = "fuzzy-logic-toolkit";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "lmarkowsky";
    repo = "fuzzy-logic-toolkit";
    tag = version;
    sha256 = "sha256-lnYzX4rq3j7rrbD8m0EnrWpbMJD6tqtMVCYu4mlLFCM=";
  };

  meta = {
    homepage = "https://github.com/lmarkowsky/fuzzy-logic-toolkit";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Mostly MATLAB-compatible fuzzy logic toolkit for Octave";
  };
}
