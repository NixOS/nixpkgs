{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, wayland-scanner
, wrapQtAppsHook
, qtbase
, qtquick3d
, qwlroots
, wayland
, wayland-protocols
, wlr-protocols
, pixman
, libdrm
, nixos-artwork
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waylib";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "vioken";
    repo = "waylib";
    rev = finalAttrs.version;
    hash = "sha256-3IdrChuXQyQGhJ/7kTqmkV0PyuSNP53Y0Po01Fc9Qi0=";
  };

  postPatch = ''
    substituteInPlace examples/tinywl/OutputDelegate.qml \
      --replace "/usr/share/wallpapers/deepin/desktop.jpg" \
                "${nixos-artwork.wallpapers.simple-blue}/share/backgrounds/nixos/nix-wallpaper-simple-blue.png"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtquick3d
    wayland
    wayland-protocols
    wlr-protocols
    pixman
    libdrm
  ];

  propagatedBuildInputs = [
    qwlroots
  ];

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_TINYWL" true)
  ];

  strictDeps = true;

  outputs = [ "out" "dev" "bin" ];

  meta = {
    description = "A wrapper for wlroots based on Qt";
    homepage = "https://github.com/vioken/waylib";
    license = with lib.licenses; [ gpl3Only lgpl3Only asl20 ];
    outputsToInstall = [ "out" ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rewine ];
  };
})

