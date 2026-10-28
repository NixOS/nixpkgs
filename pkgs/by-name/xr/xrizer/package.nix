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
  version = "0.6";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xrizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o8iZfY2WbaWS6c+RHvhbTePzZZAn0N1Iq39scp4AtRQ=";
  };

  cargoHash = "sha256-HVeKLohd73oBoiQHZE5jGwDJeLvR4J8I5zRnYvZlHoA=";

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

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "monado"
  ];

  env.XRIZER_VERSION = finalAttrs.version;

  postPatch = ''
    substituteInPlace src/graphics_backends/gl.rs \
      --replace-fail 'libGLX.so.0' '${lib.getLib libGL}/lib/libGLX.so.0'
  '';

  postInstall = ''
    mkdir -p $out/lib/xrizer/$platformPath
    mv "$out/lib/libxrizer.so" "$out/lib/xrizer/$platformPath/vrclient.so"
    touch $out/lib/xrizer/bin/version.txt
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
