{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "yamlfmt";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "yamlfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KMIkll7seKslvb4ErelpKxWg/T2P9FLYKfTyAEWlbWk=";
    leaveDotGit = true;
    postFetch = ''
      git -C "$out" rev-parse --short HEAD > "$out/.git_head"
      rm -rf "$out/.git"
    '';
  };

  vendorHash = "sha256-Cy1eBvKkQ90twxjRL2bHTk1qNFLQ22uFrOgHKmnoUIQ=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X=main.commit=$(<.git_head)"
  '';

  # Test failure in vendored yaml package, see:
  # https://github.com/google/yamlfmt/issues/256
  checkFlags = [ "-run=!S/TestNodeRoundtrip" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Extensible command line tool or library to format yaml files";
    homepage = "https://github.com/google/yamlfmt";
    changelog = "https://github.com/google/yamlfmt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "yamlfmt";
  };
})
