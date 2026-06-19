{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  testers,
  zig_0_15,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zf";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "natecraddock";
    repo = "zf";
    tag = finalAttrs.version;
    hash = "sha256-BfAZILill3I/nBf1oWwol77N34Jcpm4hudC+XSeMgZY=";
  };

  nativeBuildInputs = [
    installShellFiles
    zig_0_15
  ];

  deps = callPackage ./deps.nix {
    name = "${finalAttrs.pname}-cache-${finalAttrs.version}";
  };

  dontSetZigDefaultFlags = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
    "-Dcpu=baseline"
    "-Doptimize=ReleaseFast"
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
    version = finalAttrs.version;
  };

  meta = {
    homepage = "https://github.com/natecraddock/zf";
    description = "Commandline fuzzy finder that prioritizes matches on filenames";
    changelog = "https://github.com/natecraddock/zf/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      mmlb
    ];
    mainProgram = "zf";
  };
})
