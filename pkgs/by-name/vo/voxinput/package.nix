{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  testers,
  libpulseaudio,
  dotool,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "voxinput";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "richiejp";
    repo = "VoxInput";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ykWb5I3cd3DMDVqYrcmOtCKhLpmob7HBXs5Ek5E7/do=";
  };

  vendorHash = "sha256-OserWlRhKyTvLrYSikNCjdDdTATIcWTfqJi9n4mHVLE=";

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    libpulseaudio
    dotool
  ];

  # To take advantage of the udev rule something like `services.udev.packages = [ nixpkgs.voxinput ]`
  # needs to be added to your configuration.nix
  postInstall =
    ''
      mv $out/bin/VoxInput $out/bin/voxinput_tmp ; mv $out/bin/voxinput_tmp $out/bin/voxinput
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/voxinput \
        --prefix PATH : ${lib.makeBinPath [ dotool ]}
      mkdir -p $out/lib/udev/rules.d
      echo 'KERNEL=="uinput", GROUP="input", MODE="0620", OPTIONS+="static_node=uinput"' > $out/lib/udev/rules.d/99-voxinput.rules
    '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
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
