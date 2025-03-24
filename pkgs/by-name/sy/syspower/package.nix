{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  gtkmm4,
  gtk4-layer-shell,
}:
stdenv.mkDerivation {
  pname = "syspower";
  version = "0-unstable-2024-12-10";

  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = "syspower";
    rev = "323332b4d97a30360455682194ed35868fcbaf71";
    hash = "sha256-obL9XUf8kONBWZoyrPvN1PWmEyQx8vMsl6KIneSjkGM=";
  };

  buildInputs = [
    gtkmm4
    gtk4-layer-shell
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postFixup = ''
    wrapProgram $out/bin/syspower --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = {
    description = "Simple power menu/shutdown screen for Hyprland";
    homepage = "https://gihub.com/System64fumo/syspower";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ justdeeevin ];
    mainProgram = "syspower";
    platforms = lib.platforms.linux;
  };
}
