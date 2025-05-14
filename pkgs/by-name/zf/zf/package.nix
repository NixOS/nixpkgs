{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  testers,
  zig_0_13,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zf";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "natecraddock";
    repo = "zf";
    tag = finalAttrs.version;
    hash = "sha256-Rsl8gAfVMeF5CLyPSrtzdgSCvEwPnBwHT4BOF9JQYYo=";
  };

  nativeBuildInputs = [
    installShellFiles
    zig_0_13.hook
  ];

  postPatch = ''
    cp -a ${callPackage ./deps.nix { }}/. $ZIG_GLOBAL_CACHE_DIR/p
  '';

  postInstall = ''
    installManPage doc/zf.1
    installShellCompletion \
      --bash complete/zf \
      --fish complete/zf.fish \
      --zsh complete/_zf
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://github.com/natecraddock/zf";
    description = "Commandline fuzzy finder that prioritizes matches on filenames";
    changelog = "https://github.com/natecraddock/zf/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      dit7ya
      figsoda
      mmlb
    ];
    mainProgram = "zf";
  };
})
