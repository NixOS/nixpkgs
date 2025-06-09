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
  version = "0-unstable-2025-01-02";

  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = "syspower";
    rev = "89ddffa4b41214f9a76602cd832cce18d4283fdb";
    hash = "sha256-Qqia7JXM0LauadYoD8OCw/Yva2M+TZrhMSE8HRo8LTY=";
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
