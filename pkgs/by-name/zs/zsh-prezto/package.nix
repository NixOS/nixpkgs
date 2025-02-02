{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "zsh-prezto";
  version = "0-unstable-2025-01-10";

  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
    rev = "6e564503f1c5e6ddba2bcf5d9065e5872ca207d2";
    sha256 = "hYuYjSQtt00pU3eqrzN8Crk40NEtCCj1G6XUL89F4xU=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  buildInputs = [ bash ];

  postPatch = ''
    # make zshrc aware of where zsh-prezto is installed
    sed -i -e "s|\''${ZDOTDIR:\-\$HOME}/.zprezto/|$out/share/zsh-prezto/|g" runcoms/zshrc
  '';

  installPhase = ''
    mkdir -p $out/share/zsh-prezto
    cp -R ./ $out/share/zsh-prezto
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Configuration framework for Zsh";
    longDescription = ''
      Prezto is the configuration framework for Zsh; it enriches
      the command line interface environment with sane defaults,
      aliases, functions, auto completion, and prompt themes.
    '';
    homepage = "https://github.com/sorin-ionescu/prezto";
    license = licenses.mit;
    maintainers = with maintainers; [ holymonson ];
    platforms = platforms.unix;
  };
}
