{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  subversion,
  gnome,
}:
with lib; let
  version = "47792a3";
in
  stdenv.mkDerivation {
    pname = "thcrap-proton";
    inherit version;

    src = fetchFromGitHub {
      owner = "tactikauan";
      repo = "thcrap-steam-proton-wrapper";
      rev = version;
      sha256 = "sha256-qxjHiQrsKQdNQ9eXE7fZ5C738Ae4dG6M1yZc3J38fTU=";
    };

    buildInputs = [bash subversion];

    nativeBuildInputs = [
      makeWrapper
    ];
    installPhase = ''
      mkdir -p $out/bin
      cp thcrap_proton $out/bin/thcrap_proton
    '';
    postFixup = ''
      wrapProgram $out/bin/thcrap_proton \
        --prefix PATH : ${lib.makeBinPath [bash subversion gnome.zenity]}
    '';
    meta = {
      description = "A wrapper script for launching the official Touhou games on Steam with patches through Proton on GNU/Linux";
      homepage = "https://github.com/tactikauan/thcrap-steam-proton-wrapper";
      changelog = "https://github.com/tactikauan/thcrap-steam-proton-wrapper/${version}";
      license = licenses.unlicense;
      maintainers = with maintainers; [ashuramaruzxc];
      platforms = ["x86_64-linux" "aarch64-linux"];
      mainProgram = "thcrap_proton";
    };
  }
