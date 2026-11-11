{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  zsh,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zsh-autocomplete";
  version = "26.08.04";

  src = fetchFromGitHub {
    owner = "marlonrichert";
    repo = "zsh-autocomplete";
    rev = version;
    sha256 = "sha256-aba38Cmnps2n6Tr/1i3BjPZ4TbQPsDBURXF1fcd8cDI=";
  };

  strictDeps = true;

  nativeInstallCheckInputs = [ zsh ];

  installPhase = ''
    install -D zsh-autocomplete.plugin.zsh $out/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    install -D z-async/z-async $out/share/zsh-autocomplete/z-async/z-async
    cp -R Completions $out/share/zsh-autocomplete/Completions
    cp -R Functions $out/share/zsh-autocomplete/Functions
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    zsh -f -c '
      fpath=( "$out/share/zsh-autocomplete/z-async" )
      autoload -Uz z-async
      z-async help >/dev/null
    '

    runHook postInstallCheck
  '';

  meta = {
    description = "Real-time type-ahead completion for Zsh. Asynchronous find-as-you-type autocompletion";
    homepage = "https://github.com/marlonrichert/zsh-autocomplete/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.leona ];
  };
}
