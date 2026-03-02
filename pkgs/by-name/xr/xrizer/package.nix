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
  version = "0.4";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xrizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IRhLWlGHywp0kZe5aGmMHAF1zZwva3sGg68eG1E2K9A=";
  };

  patches = [
    # https://github.com/Supreeeme/xrizer/pull/262
    (fetchpatch2 {
      name = "xrizer-fix-aarch64.patch";
      url = "https://github.com/Supreeeme/xrizer/commit/70ea6f616cd7608462cdf2f5bf76a85acf23fe33.patch?full_index=1";
      hash = "sha256-Bwu/GjsaoS1VqpXmijBuZcJFUf6kRYWYWpGxm40AWyc=";
    })
  ];

  cargoHash = "sha256-orfK5pwWv91hA7Ra3Kk+isFTR+qMHSZ0EYZTVbf0fO0=";

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
