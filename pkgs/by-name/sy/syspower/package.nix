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
  version = "0-unstable-2025-12-31";

  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = "syspower";
    rev = "1a74a7895a02363dfcc23bb43cd3f7d7d8ad3320";
    hash = "sha256-gLkjyhLA0QDG/89uTp32VEoOlTGaDjqZm1aLy+X36qw=";
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
    homepage = "https://github.com/System64fumo/syspower";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ justdeeevin ];
    mainProgram = "syspower";
    platforms = lib.platforms.linux;
  };
}
