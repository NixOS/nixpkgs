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
    hash = "sha256-iznyTYDvFr1wuDZVwd1VTcB179SZQ2L0ZSY9g7BFDgg=";
  };

  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D bd.zsh \
      $out/share/plugins/zsh-bd/bd.zsh
    ln -s $out/share/plugins/zsh-bd/bd.zsh \
      $out/share/plugins/zsh-bd/bd.plugin.zsh
    ln -s $out/share/plugins/zsh-bd \
      $out/share/zsh-bd

    runHook postInstall
  '';

  meta = {
    description = "Jump back to a specific directory, without doing `cd ../../..`";
    homepage = "https://github.com/Tarrasch/zsh-bd";
    license = lib.licenses.free;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.olejorgenb ];
  };
}
