{
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  libpulseaudio,
  dotool,
  libGL,
  xorg,
  libxkbcommon,
  wayland,
  lib,
  stdenv,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "voxinput";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "richiejp";
    repo = "VoxInput";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aFsAAT3hNbTSSkeMH65+jnhpjJRxVvfRUiiXdKIvZqM=";
  };

  vendorHash = "sha256-jopDuqIuc45zT36B7D7WCtYtdZUn4hvE45s/FLBGrms=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    libpulseaudio
    dotool

    libGL
    xorg.libX11.dev
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXxf86vm
    libxkbcommon
    wayland
  ];

  # To take advantage of the udev rule something like `services.udev.packages = [ nixpkgs.voxinput ]`
  # needs to be added to your configuration.nix
  postInstall = ''
    mv $out/bin/VoxInput $out/bin/voxinput_tmp ; mv $out/bin/voxinput_tmp $out/bin/voxinput
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/voxinput \
      --prefix PATH : ${lib.makeBinPath [ dotool ]}
    mkdir -p $out/lib/udev/rules.d
    echo 'KERNEL=="uinput", GROUP="input", MODE="0620", OPTIONS+="static_node=uinput"' > $out/lib/udev/rules.d/99-voxinput.rules
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isElf ''
    patchelf $out/bin/.voxinput-wrapped \
      --add-rpath ${lib.makeLibraryPath [ libpulseaudio ]}
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "voxinput ver";
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    homepage = "https://github.com/richiejp/VoxInput";
    description = "Voice to text for any Linux app via dotool/uinput and the LocalAI/OpenAI transcription API";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.richiejp ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/richiejp/VoxInput/releases/tag/v${finalAttrs.version}";
    mainProgram = "voxinput";
  };
})
