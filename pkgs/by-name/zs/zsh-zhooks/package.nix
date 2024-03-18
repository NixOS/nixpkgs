{ lib, stdenv, fetchFromGitHub }:
let
  pname = "zhooks";
  install_path = "share/zsh/${pname}";
in
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-10-31-2021";
  src = fetchFromGitHub {
    owner = "agkozak";
    repo = "zhooks";
    rev = "e6616b4a2786b45a56a2f591b79439836e678d22";
    sha256 = "sha256-zahXMPeJ8kb/UZd85RBcMbomB7HjfEKzQKjF2NnumhQ=";
  };
  dontBuild = true;
  installPhase = ''
    install -m755 -D ${pname}.plugin.zsh --target-directory $out/${install_path}
  '';
  meta = with lib; {
    homepage = "https://github.com/agkozak/zhooks";
    license = licenses.mit;
    description = "A tool for displaying the code for all Zsh hook functions";
    longDescription = ''
      This Zsh plugin is a tool for displaying the code for all Zsh hook functions (such as precmd), as well as the contents of
      hook arrays (such as precmd_functions).
      ```
    '';
    maintainers = with maintainers; [ fidgetingbits ];
  };
}
