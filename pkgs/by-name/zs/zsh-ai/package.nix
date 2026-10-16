{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zsh-ai";
  version = "0.11.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "matheusml";
    repo = "zsh-ai";
    rev = "v${version}";
    sha256 = "sha256-yN2+VmxXzBcJzLc0Ml1omJcUOftYe4CXkAAGUXC7txk=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m644 zsh-ai.plugin.zsh $out/share/zsh-ai/zsh-ai.plugin.zsh
    cp -r lib $out/share/zsh-ai/

    runHook postInstall
  '';

  meta = {
    description = "Natural language shell command generator for Zsh using AI";
    homepage = "https://github.com/matheusml/zsh-ai";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ _2hexed ];
  };
}
