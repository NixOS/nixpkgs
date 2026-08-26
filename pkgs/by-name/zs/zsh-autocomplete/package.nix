{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zsh-autocomplete";
  version = "26.08.03";

  src = fetchFromGitHub {
    owner = "marlonrichert";
    repo = "zsh-autocomplete";
    rev = version;
    sha256 = "sha256-NZLlRJZobUj3W94mRG245lGqDb1hE9x0nC9tRx58+Js=";
  };

  strictDeps = true;
  installPhase = ''
    install -D zsh-autocomplete.plugin.zsh $out/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    cp -R Completions $out/share/zsh-autocomplete/Completions
    cp -R Functions $out/share/zsh-autocomplete/Functions
  '';

  meta = {
    description = "Real-time type-ahead completion for Zsh. Asynchronous find-as-you-type autocompletion";
    homepage = "https://github.com/marlonrichert/zsh-autocomplete/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.leona ];
  };
}
