{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "zsh-bd";
  version = "2018-07-04";

  src = fetchFromGitHub {
    owner = "Tarrasch";
    repo = "zsh-bd";
    rev = "d4a55e661b4c9ef6ae4568c6abeff48bdf1b1af7";
    sha256 = "020f8nq86g96cps64hwrskppbh2dapfw2m9np1qbs5pgh16z4fcb";
  };

  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/zsh-bd
    cp {.,$out/share/zsh-bd}/bd.zsh
    cd $out/share/zsh-bd
    ln -s bd{,.plugin}.zsh
  '';

  meta = {
    description = "Jump back to a specific directory, without doing `cd ../../..`";
    homepage = "https://github.com/Tarrasch/zsh-bd";
    license = lib.licenses.free;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.olejorgenb ];
  };
}
