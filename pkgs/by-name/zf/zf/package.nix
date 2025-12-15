{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  testers,
  zig_0_15,
  callPackage,
}:

let
  zig = zig_0_15;
  zig_hook = zig.hook.overrideAttrs {
    zig_default_flags = "-Dcpu=baseline -Doptimize=ReleaseFast --color off";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zf";
  upstreamVersion = "0.10.3";
  version = "${finalAttrs.upstreamVersion}-unstable-2025-10-14";
  rev = "3c52637b7e937c5ae61fd679717da3e276765b23";

  src = fetchFromGitHub {
    owner = "natecraddock";
    repo = "zf";
    rev = finalAttrs.rev;
    hash = "sha256-BfAZILill3I/nBf1oWwol77N34Jcpm4hudC+XSeMgZY=";
  };

  nativeBuildInputs = [
    installShellFiles
    zig_hook
  ];

  deps = callPackage ./deps.nix {
    name = "${finalAttrs.pname}-cache-${finalAttrs.version}";
  };

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  postInstall = ''
    installManPage doc/zf.1
    installShellCompletion \
      --bash complete/zf \
      --fish complete/zf.fish \
      --zsh complete/_zf
  '';

  zigCheckFlags = finalAttrs.zigBuildFlags;
  doCheck = true;
  doInstallCheck = true;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.upstreamVersion;
  };

  meta = {
    homepage = "https://github.com/natecraddock/zf";
    description = "Commandline fuzzy finder that prioritizes matches on filenames";
    changelog = "https://github.com/natecraddock/zf/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      dit7ya
      mmlb
    ];
    mainProgram = "zf";
  };
})
