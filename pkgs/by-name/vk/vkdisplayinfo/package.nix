{
  lib,
  stdenv,
  meson,
  ninja,
  vulkan-loader,
  vulkan-headers,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vkdisplayinfo";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "ChristophHaag";
    repo = "vkdisplayinfo";
    rev = finalAttrs.version;
    hash = "sha256-n6U7T5aOYTpgWE2WGPBPHtQKzitf9PxAoXJNWyz4rYw=";
  };

  postInstall = ''
    install vkdisplayinfo -Dm755 -t $out/bin
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    ($out/bin/vkdisplayinfo 2>&1 || true) | grep -q vkdisplayinfo
    runHook postInstallCheck
  '';

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    vulkan-loader
    vulkan-headers
  ];

  meta = {
    description = "Print displays and modes enumerated with the Vulkan function vkGetPhysicalDeviceDisplayPropertiesKHR";
    homepage = "https://github.com/ChristophHaag/vkdisplayinfo";
    platforms = lib.platforms.linux;
    license = lib.licenses.boost;
    maintainers = [ lib.maintainers.LunNova ];
    mainProgram = "vkdisplayinfo";
  };
})
