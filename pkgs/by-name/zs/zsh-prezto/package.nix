{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "zsh-prezto";
  version = "0-unstable-2024-12-12";

  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
    rev = "9626ce2beb8e20afb8f63020d974ff8a213bc773";
    sha256 = "TkmzNyPKv/K9sW0CCiR8hnXXM0d6En49HcdPsa011Xw=";
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
