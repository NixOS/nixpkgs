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
rustPlatform.buildRustPackage rec {
  pname = "xrizer";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xrizer";
    tag = "v${version}";
    hash = "sha256-o6/uGbczYp5t6trjFIltZAMSM61adn+BvNb1fBhBSsk=";
  };

  patches = [
    (fetchpatch2 {
      name = "xrizer-fix-flaky-tests.patch";
      url = "https://github.com/Supreeeme/xrizer/commit/f58d797e75a8d920982abeaeedee83877dd3c493.diff?full_index=1";
      hash = "sha256-TI++ZY7QX1iaj3WT0woXApSY2Tairraao5kzF77ewYY=";
    })
  ];

  cargoHash = "sha256-kXcnD98ZaqRAA3jQvIoWSRC37Uq8l5PUYEzubxfMuUI=";

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
    ln -s "$out/lib/libxrizer.so" "$out/lib/xrizer/$platformPath/vrclient.so"
  '';

  platformPath =
    {
      "aarch64-linux" = "bin/linuxarm64";
      "i686-linux" = "bin";
      "x86_64-linux" = "bin/linux64";
    }
    ."${stdenv.hostPlatform.system}";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "XR-ize your favorite OpenVR games";
    homepage = "https://github.com/Supreeeme/xrizer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];
  };
}
