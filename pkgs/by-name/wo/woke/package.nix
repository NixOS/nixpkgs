{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "woke";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "get-woke";
    repo = "woke";
    tag = "v${version}";
    hash = "sha256-X9fhExHhOLjPfpwrYPMqTJkgQL2ruHCGEocEoU7m6fM=";
  };

  vendorHash = "sha256-lRUvoCiE6AkYnyOCzev1o93OhXjJjBwEpT94JTbIeE8=";

  # Tests require internet access and/or fail when building with Nix
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/get-woke/woke/cmd.Version=${version}"
    "-X=github.com/get-woke/woke/cmd.Commit=${src.tag}"
    "-X=github.com/get-woke/woke/cmd.Date=1970-01-01T00:00:00Z"
  ];

  postInstall = "rm $out/bin/docs";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/woke";
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/get-woke/woke/releases/tag/${src.tag}";
    description = "Detect non-inclusive language in your source code";
    homepage = "https://github.com/get-woke/woke";
    license = lib.licenses.mit;
    mainProgram = "woke";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
