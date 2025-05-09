{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  dmidecode,
  makeWrapper,
  nix-update-script,
}:

let
  isPlatformSupported = drv: builtins.elem stdenv.hostPlatform.system drv.meta.platforms;
  runtimeDeps = builtins.filter isPlatformSupported [
    dmidecode
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vmaware";
  version = "2.1.1";
  src = fetchFromGitHub {
    owner = "kernelwernel";
    repo = "VMAware";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+gvi1qs8y3Rj0m0+bgqQJTXbCQ4ZATHPTwDB6Ro+Ttc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    makeWrapper
  ];

  patchPhase = ''
    runHook prePatch

    substituteInPlace CMakeLists.txt --replace-fail "/usr/local/bin" "$out/bin"
    substituteInPlace CMakeLists.txt --replace-fail "/usr/include" "$out/include"

    runHook postPatch
  '';

  postFixup = ''
    wrapProgram $out/bin/vmaware \
      --prefix PATH : "${lib.makeBinPath runtimeDeps}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "VM detection library and tool";
    homepage = "https://github.com/kernelwernel/VMAware";
    changelog = "https://github.com/kernelwernel/VMAware/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3
      mit
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ners ];
    mainProgram = "vmaware";
  };
})
