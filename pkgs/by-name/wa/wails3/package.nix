{
  buildGoModule,
  fetchFromGitHub,
  webkitgtk_6_0,
  pkg-config,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "wails3";
  version = "3.0.0-alpha2.106";

  src = fetchFromGitHub {
    owner = "wailsapp";
    repo = "wails";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tSX6HVkjtZ+XLVfkPedaF1K8JSqbLl+5si+86fEjZrA=";
  };

  vendorHash = "sha256-W6H9mviQdTVPfG+r4M1tNWaVP5JChY5/rLAv8kXG8rI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    webkitgtk_6_0
  ];

  subPackages = [ "cmd/wails3" ];

  proxyVendor = true;

  env.GOWORK = "off";

  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/v3";

  meta = {
    description = "Build desktop applications using Go & Web Technologies";
    homepage = "https://wails.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Simon-Weij ];
    mainProgram = "wails3";
    platforms = lib.platforms.linux;
  };
})
