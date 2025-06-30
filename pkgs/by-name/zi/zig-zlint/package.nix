{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig_0_14,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zig-zlint";
  version = "0.7.6";

  src = fetchFromGitHub {
    name = "zlint"; # tests expect this
    owner = "DonIsaac";
    repo = "zlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S0FhugmrNHCEpIWX7oL1vZ8heikpo/mok7ciTgSdOpg=";
  };

  nativeBuildInputs = [
    zig_0_14.hook
  ];

  zigBuildFlags = [
    "-Dversion=v${finalAttrs.version}"
    "--system"
    (callPackage ./build.zig.zon.nix { })
  ];

  doCheck = true;
  zigCheckFlags = finalAttrs.zigBuildFlags;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/zlint";
  versionCheckProgramArg = "--version";

  # `zig build` produces a lot more artifacts, just copy over the ones we want
  installPhase = ''
    runHook preInstall
    install -vDm755 zig-out/bin/zlint $out/bin/zlint
    runHook postInstall
  '';

  meta = {
    description = "Linter for the Zig programming language";
    homepage = "https://github.com/DonIsaac/zlint";
    changelog = "https://github.com/DonIsaac/zlint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ christoph-heiss ];
    mainProgram = "zlint";
    inherit (zig_0_14.meta) platforms;
  };
})
