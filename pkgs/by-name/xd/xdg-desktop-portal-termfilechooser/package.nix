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
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-termfilechooser";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hunkyburrito";
    repo = "xdg-desktop-portal-termfilechooser";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-7fbQ0iraT3UQFgpb9Jlfo0myS72IiH5+vyU7dAzldfM=";
=======
    hash = "sha256-IlPNNuQaGVW5QXcyA8cWiFJxwgXmviQoisDUWX9QP2s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

  passthru.updateScript = nix-update-script { };

<<<<<<< HEAD
  meta = {
    description = "xdg-desktop-portal backend for choosing files with your favorite file chooser";
    homepage = "https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "xdg-desktop-portal backend for choosing files with your favorite file chooser";
    homepage = "https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser";
    license = licenses.mit;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [
      body20002
      ltrump
    ];
    mainProgram = "xdg-desktop-portal-termfilechooser";
  };
})
