{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "syft";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = "syft";
    tag = "v${version}";
    hash = "sha256-J9ia5VjEItwDS2YjKAGAuQTTig5IIQA70yBYM/2r4B4=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };
  # hash mismatch with darwin
  proxyVendor = true;

  vendorHash = "sha256-r1P3dWNiVLDFLJ5IM/VHdMTDS/Yh+pb8VODxEnmxmks=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/syft" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.gitDescription=v${version}"
    "-X=main.gitTreeState=clean"
  ];

  postPatch = ''
    # Don't check for updates.
    substituteInPlace cmd/syft/internal/options/update_check.go \
      --replace-fail "CheckForAppUpdate: true" "CheckForAppUpdate: false"
  '';

  preBuild = ''
    ldflags+=" -X main.gitCommit=$(cat COMMIT)"
    ldflags+=" -X main.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  # tests require a running docker instance
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd syft \
      --bash <($out/bin/syft completion bash) \
      --fish <($out/bin/syft completion fish) \
      --zsh <($out/bin/syft completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/syft --help
    $out/bin/syft version | grep "${version}"

    runHook postInstallCheck
  '';

  meta = {
    description = "CLI tool and library for generating a Software Bill of Materials from container images and filesystems";
    homepage = "https://github.com/anchore/syft";
    changelog = "https://github.com/anchore/syft/releases/tag/v${version}";
    longDescription = ''
      A CLI tool and Go library for generating a Software Bill of Materials
      (SBOM) from container images and filesystems. Exceptional for
      vulnerability detection when used with a scanner tool like Grype.
    '';
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [
      developer-guy
      jk
      kashw2
    ];
    mainProgram = "syft";
  };
}
