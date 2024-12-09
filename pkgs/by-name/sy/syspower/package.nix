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
    rev = "b205c3443daaee6c3454f23b93b78f42c10221a1";
    hash = "sha256-kLaWIaMTRurY7a8Nn7C9ft/Zdvx35AiU7Db8n/NFy90=";
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
