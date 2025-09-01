{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  bash,
}:

stdenv.mkDerivation {
  pname = "zsh-prezto";
  version = "0-unstable-2025-07-30";

  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
    rev = "af383940911fc3192beb6e0fd2566c52bd1ea9ba";
    sha256 = "UWDOT6ezJ1LepULU2fqDru/sFcuUh41eP3C9ay8x888=";
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
