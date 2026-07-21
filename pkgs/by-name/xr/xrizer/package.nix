{
  fetchFromGitHub,
  fetchpatch2,
  lib,
  libGL,
  libxkbcommon,
  nix-update-script,
  openxr-loader,
  pkg-config,
  rustPlatform,
  shaderc,
  vulkan-loader,
  stdenv,
}:
let
  platformPaths = {
    "aarch64-linux" = "bin/linuxarm64";
    "i686-linux" = "bin";
    "x86_64-linux" = "bin/linux64";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xrizer";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xrizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y/K+eXECUi9wGol0IUuIUI9hqhEN8GHaOO5i1xMFNQo=";
  };

  cargoHash = "sha256-btGPIujawY5NPmx7hGBxW5ZYi2RvboyQpfw6fA3c3jE=";

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
    mkdir -p $out/lib/xrizer/$platformPath
    mv "$out/lib/libxrizer.so" "$out/lib/xrizer/$platformPath/vrclient.so"
  '';

  platformPath = platformPaths."${stdenv.hostPlatform.system}";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "XR-ize your favorite OpenVR games";
    homepage = "https://github.com/Supreeeme/xrizer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
    platforms = builtins.attrNames platformPaths;
  };
})
