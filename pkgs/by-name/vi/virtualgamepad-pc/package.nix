{
    lib,
    stdenv,
    fetchFromGitHub,
    cmake,
    qt6,
    pkg-config,
    libevdev,
    qrcodegencpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "virtualgamepad-pc";
  version = "0.4.0";

  src = fetchFromGitHub {
      owner = "kitswas";
      repo = "VirtualGamePad-PC";
      tag = "v${finalAttrs.version}";
      sha256 = "sha256-IsUNF+YjBGSuxrxn9CZrq7UWODeAocDwOtm9L1HxeHE=";
  };

  VGP_Data_Exchange = fetchFromGitHub {
    owner = "kitswas";
    repo = "VGP_Data_Exchange";
    rev = "3b1496d03f841b229741b5b4eb6e127ef88ad8a3";
    sha256 = "sha256-NW6HbDzBDoQ6MwN749imgmqZhtHC/QpQ9kL03H8tF5U=";
  };

  patches = [
    ./qrencodegen.patch
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

  postUnpack = ''
    ln -s ${finalAttrs.VGP_Data_Exchange}/* source/VGP_Data_Exchange
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp VGamepadPC $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://kitswas.github.io/VirtualGamePad/";
    description = "Android phone as gamepad for PCs";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ poyo86 ];
    platforms = lib.platforms.linux;
    mainProgram = "VGamepadPC";
  };
})
