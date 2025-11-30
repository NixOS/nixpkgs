{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "zsh-navigation-tools";
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "psprint";
    repo = "zsh-navigation-tools";
    rev = "v${version}";
    sha256 = "0c4kb19aprb868xnlyq8h1nd2d32r0zkrqblsrzvg7m9gx8vqps8";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/zsh/site-functions/
    cp zsh-navigation-tools.plugin.zsh $out/share/zsh/site-functions/
    cp n-* $out/share/zsh/site-functions/
    cp znt-* $out/share/zsh/site-functions/
    mkdir -p $out/share/zsh/site-functions/.config/znt
    cp .config/znt/n-* $out/share/zsh/site-functions/.config/znt
  '';

  meta = with lib; {
    description = "Curses-based tools for ZSH";
    homepage = "https://github.com/psprint/zsh-navigation-tools";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
