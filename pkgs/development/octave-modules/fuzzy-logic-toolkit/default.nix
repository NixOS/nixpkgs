{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
}:

buildOctavePackage rec {
  pname = "fuzzy-logic-toolkit";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "lmarkowsky";
    repo = "fuzzy-logic-toolkit";
    tag = version;
    sha256 = "sha256-cNzUjhJgx6SVfy8QrKUr02HvNsAh5ItQN3+hapA5eq0=";
  };

  meta = {
    homepage = "https://github.com/lmarkowsky/fuzzy-logic-toolkit";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Mostly MATLAB-compatible fuzzy logic toolkit for Octave";
  };
}
