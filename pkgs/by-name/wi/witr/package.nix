{
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "witr";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "pranshuparmar";
    repo = "witr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U93fdcJ6Xdo2Z9WMVCFR2wxo1dhXVFd5MWGTF8B9a3M=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = null;

  ldflags = [
    "-X main.version=v${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X=main.commit=$(cat COMMIT)"
    ldflags+=" -X=main.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage docs/witr.1
  '';

  meta = {
    description = "Command-line tool to find out why processes are running";
    homepage = "https://github.com/pranshuparmar/witr";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thegu5 ];
    mainProgram = "witr";
  };
})
