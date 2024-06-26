{ lib, mkDerivation, fetchFromGitHub }:

mkDerivation rec {
  version = "unstable-2023-10-04";
  pname = "agda-prelude";

  src = fetchFromGitHub {
    owner = "UlfNorell";
    repo = "agda-prelude";
    rev = "ff3b13253612caf0784a06e2d7d0f30be16c32e4";
    hash = "sha256-A05uDv3fJqKncea9AL6eQa0XAskLZwAIUl1OAOVeP8I=";
  };

  preConfigure = ''
    cd test
    make everything
    mv Everything.agda ..
    cd ..
  '';

  meta = with lib; {
    homepage = "https://github.com/UlfNorell/agda-prelude";
    description = "Programming library for Agda";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ mudri alexarice turion ];
  };
}
