{
  lib,
  stdenv,
  fetchFromGitHub,
}:

# To make use of this derivation, use the `programs.zsh.enableSyntaxHighlighting` option

stdenv.mkDerivation (finalAttrs: {
  version = "0.8.0";
  pname = "zsh-syntax-highlighting";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-syntax-highlighting";
    rev = finalAttrs.version;
    hash = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
  };

  strictDeps = true;

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Fish shell like syntax highlighting for Zsh";
    homepage = "https://github.com/zsh-users/zsh-syntax-highlighting";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      gepbird
      loskutov
    ];
  };
})
