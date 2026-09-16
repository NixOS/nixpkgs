{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  pkg-config,
  libevdev,
  qrcodegencpp,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "virtualgamepad-pc";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "kitswas";
    repo = "VirtualGamePad-PC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lE/0ucdeShL3RRlKh4UmrlHdajQpQqO2/SA/NwLi0ZM=";
  };

  passthru.VGP_Data_Exchange = fetchFromGitHub {
    owner = "kitswas";
    repo = "VGP_Data_Exchange";
    rev = "3b1496d03f841b229741b5b4eb6e127ef88ad8a3";
    hash = "sha256-NW6HbDzBDoQ6MwN749imgmqZhtHC/QpQ9kL03H8tF5U=";
  };

  patches = [
    ./qrcodegen.patch
    # Allow disabling portable build
    (fetchpatch {
      url = "https://github.com/kitswas/VirtualGamePad-PC/commit/bdd1a87de9b4212ed9afe0728bdad3f9f615d374.patch";
      hash = "sha256-melXSRRA6V+zqcfCsO9D7AnoPH8MwmjJBHImcdaoBmM=";
    })
  ];

  buildInputs = [
    qt6.qtbase
    libevdev
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pkg-config
    qrcodegencpp
  ];

  cmakeFlags = [
    (lib.cmakeBool "PORTABLE_BUILD" false)
  ];

  postUnpack = ''
    ln -s ${finalAttrs.passthru.VGP_Data_Exchange}/* source/VGP_Data_Exchange
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 VGamepadPC -t $out/bin
    install -Dm444 $src/res/VGamepadPC.desktop -t $out/share/applications
    install -Dm444 $src/res/logos/SquareIcon.png $out/share/icons/hicolor/256x256/icons/VGamepadPC.png
    runHook postInstall
  '';

  meta = {
    homepage = "https://kitswas.github.io/VirtualGamePad/";
    description = "Android phone as gamepad for PCs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ poyo86 ];
    platforms = lib.platforms.linux;
    mainProgram = "VGamepadPC";
  };
})
