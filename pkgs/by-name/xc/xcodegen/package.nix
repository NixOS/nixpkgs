{
  lib,
  swiftPackages,
  swift,
  swiftpm,
  swiftpm2nix,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

let
  # Pass the generated files to the helper.
  generated = swiftpm2nix.helpers ./nix;
in

swiftPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "xcodegen";
  version = "2.44.1";

  src = fetchFromGitHub {
    owner = "yonaskolb";
    repo = "XcodeGen";
    tag = finalAttrs.version;
    hash = "sha256-RQlmQfmrLZRrgIA09fE84JuqmYkkrz4KSw2dvYXw0Rs=";
  };

  # Including SwiftPM as a nativeBuildInput provides a buildPhase for you.
  # This by default performs a release build using SwiftPM, essentially:
  #   swift build -c release
  nativeBuildInputs = [
    swift
    swiftpm
  ];

  buildInputs = [
    swiftPackages.XCTest
  ];

  # The helper provides a configure snippet that will prepare all dependencies
  # in the correct place, where SwiftPM expects them.
  configurePhase = generated.configure + ''
    # Replace the dependency symlink with a writable copy
    swiftpmMakeMutable Spectre
    # Now apply a patch
    patch -p1 -d .build/checkouts/Spectre -i ${./0001-spectre-xct-record.patch}
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/xcodegen
    cp "$(swiftpmBinPath)/${finalAttrs.pname}" $out/bin/
    cp -r SettingPresets $out/share/xcodegen/SettingPresets
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Swift command line tool for generating your Xcode project";
    homepage = "https://github.com/yonaskolb/XcodeGen";
    changelog = "https://github.com/XcodeGen/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = [ lib.maintainers.samasaur ];
    mainProgram = "xcodegen";
  };
})
