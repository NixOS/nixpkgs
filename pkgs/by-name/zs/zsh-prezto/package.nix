{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "zsh-prezto";
  version = "0-unstable-2024-06-03";

  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
    rev = "9195b66161b196238cbd52a8a4abd027bdaf5f73";
    sha256 = "wN/86uFBahUWl9RnKvdf88zVxou7B8Kh7/s3JfMye0g=";
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
