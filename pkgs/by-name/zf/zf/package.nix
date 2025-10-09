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
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zf";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "natecraddock";
    repo = "zf";
    tag = finalAttrs.version;
    hash = "sha256-RHGck3cZx9hzh+z5BexO3k9thda73qSq5ugy0Ouh2QI=";
  };

  nativeBuildInputs = [
    installShellFiles
    zig.hook
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
