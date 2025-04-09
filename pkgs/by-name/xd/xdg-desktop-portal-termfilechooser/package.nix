{
  stdenv,
  fetchFromGitHub,
  lib,
  xdg-desktop-portal,
  ninja,
  meson,
  pkg-config,
  inih,
  systemd,
  scdoc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-termfilechooser";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "hunkyburrito";
    repo = "xdg-desktop-portal-termfilechooser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uwUND1K0UCztDS68APZf578zhvVm0BhL3f7dLrdKTHE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    xdg-desktop-portal
    inih
    systemd
  ];

  mesonFlags = [ "-Dsd-bus-provider=libsystemd" ];

  meta = with lib; {
    description = "xdg-desktop-portal backend for choosing files with your favorite file chooser";
    homepage = "https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ body20002 ];
    mainProgram = "xdg-desktop-portal-termfilechooser";
  };
})
