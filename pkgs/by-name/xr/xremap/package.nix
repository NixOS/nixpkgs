{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  x11Support ? false,
  gnomeSupport ? false,
  kdeSupport ? false,
  wlrootsSupport ? false,
  hyprlandSupport ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "xremap";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = "xremap";
    tag = "v${version}";
    hash = "sha256-cd1VLwP2/tBi8tmqnuTY5PVcMfSE5u6y7QI4F53otlY=";
  };

  cargoHash = "sha256-wvOGyvgi6X9vWAYIHOQyEB9B0oeSdUpi/3LYPB262vI=";
  useFetchCargoVendor = true;

  buildNoDefaultFeatures = true;
  buildFeatures =
    (lib.optionals x11Support [ "x11" ])
    ++ (lib.optionals gnomeSupport [ "gnome" ])
    ++ (lib.optionals kdeSupport [ "kde" ])
    ++ (lib.optionals wlrootsSupport [ "wlroots" ])
    ++ (lib.optionals hyprlandSupport [ "hypr" ]);

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Key remapper for X11 and Wayland";
    homepage = "https://github.com/k0kubun/xremap";
    changelog = "https://github.com/k0kubun/xremap/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "xremap";
    maintainers = [ lib.maintainers.hakan-demirli ];
    platforms = lib.platforms.linux;
  };
}
