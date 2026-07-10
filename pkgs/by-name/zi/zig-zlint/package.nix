{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig_0_15,
  versionCheckHook,
}:

let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zig-zlint";
  version = "0.8.1";

  src = fetchFromGitHub {
    name = "zlint"; # tests expect this
    owner = "DonIsaac";
    repo = "zlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yjMgmO/kjLA9eBPXY+TgfVLyOLIpBtBigItJuon+t9k=";
  };

  nativeBuildInputs = [
    zig
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
    inherit (zig.meta) platforms;
  };
})
