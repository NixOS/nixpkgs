{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "zsh-zhooks";
  version = "0-unstable-10-31-2021";

  src = fetchFromGitHub {
    owner = "agkozak";
    repo = "zhooks";
    rev = "e6616b4a2786b45a56a2f591b79439836e678d22";
    sha256 = "sha256-zahXMPeJ8kb/UZd85RBcMbomB7HjfEKzQKjF2NnumhQ=";
  };

  dontBuild = true;

  installPhase = ''
    install -m755 -D zhooks.plugin.zsh --target-directory $out/share/zsh/zhooks
  '';

  meta = {
    description = "A tool for displaying the code for all Zsh hook functions";
    homepage = "https://github.com/agkozak/zhooks";
    license = lib.licenses.mit;
    longDescription = ''
      This Zsh plugin is a tool for displaying the code for all Zsh hook functions (such as precmd), as well as the contents of
      hook arrays (such as precmd_functions).
    '';
    maintainers = [ lib.maintainers.fidgetingbits ];
  };
}
