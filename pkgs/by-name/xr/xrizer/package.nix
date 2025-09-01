{
  fetchFromGitHub,
  lib,
  libGL,
  libxkbcommon,
  nix-update-script,
  openxr-loader,
  pkg-config,
  rustPlatform,
  shaderc,
  vulkan-loader,
}:
rustPlatform.buildRustPackage rec {
  pname = "xrizer";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xrizer";
    tag = "v${version}";
    hash = "sha256-0RICNxF8RBHthve69Z9msTg2+jegg5K4aHYRF0YZ8a4=";
  };

  cargoHash = "sha256-87JcULH1tAA487VwKVBmXhYTXCdMoYM3gOQTkM53ehE=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    shaderc
  ];

  buildInputs = [
    libxkbcommon
    vulkan-loader
    openxr-loader
  ];

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'features = ["static"]' 'features = ["linked"]'
    substituteInPlace src/graphics_backends/gl.rs \
      --replace-fail 'libGLX.so.0' '${lib.getLib libGL}/lib/libGLX.so.0'
  '';

  postInstall = ''
    mkdir -p $out/lib/xrizer/bin/linux64
    ln -s "$out/lib/libxrizer.so" "$out/lib/xrizer/bin/linux64/vrclient.so"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "XR-ize your favorite OpenVR games";
    homepage = "https://github.com/Supreeeme/xrizer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
    # TODO: support more systems
    # To do so, we need to map systems to the format openvr expects.
    # i.e. x86_64-linux -> linux64, aarch64-linux -> linuxarm64
    platforms = [ "x86_64-linux" ];
  };
}
