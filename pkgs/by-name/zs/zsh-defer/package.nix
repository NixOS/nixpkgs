{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "zsh-defer";
  version = "0-unstable-2022-06-13";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "zsh-defer";
    rev = "57a6650ff262f577278275ddf11139673e01e471";
    sha256 = "sha256-/rcIS2AbTyGw2HjsLPkHtt50c2CrtAFDnLuV5wsHcLc=";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/zsh-defer
    cp zsh-defer* $out/share/zsh-defer
  '';

  meta = with lib; {
    description = "Deferred execution of zsh commands";
    homepage = "https://github.com/romkatv/zsh-defer";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.vinnymeller ];
  };
}
