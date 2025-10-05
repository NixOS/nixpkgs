{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "vexctl";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "openvex";
    repo = "vexctl";
    tag = "v${version}";
    hash = "sha256-LAl56aB7bFXrXK8wSAmQleWTy8q9Gx1+fxpmSTMp2Cg=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # '0000-00-00T00:00:00Z'
      date -u -d "@$(git log -1 --pretty=%ct)" "+'%Y-%m-%dT%H:%M:%SZ'" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-G0w5auYmSED6ktTDayfOSu/9QQLTuFCkjW/f9ekn/Hw=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=v${version}"
    "-X sigs.k8s.io/release-utils/version.gitTreeState=clean"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X sigs.k8s.io/release-utils/version.gitCommit=$(cat COMMIT)"
    ldflags+=" -X sigs.k8s.io/release-utils/version.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd vexctl \
      --bash <($out/bin/vexctl completion bash) \
      --fish <($out/bin/vexctl completion fish) \
      --zsh <($out/bin/vexctl completion zsh)
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "version";

  meta = {
    homepage = "https://github.com/openvex/vexctl";
    description = "Tool to create, transform and attest VEX metadata";
    mainProgram = "vexctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jk ];
  };
}
