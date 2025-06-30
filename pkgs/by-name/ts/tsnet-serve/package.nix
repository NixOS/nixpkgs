{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tsnet-serve";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "shayne";
    repo = "tsnet-serve";
    tag = "v${version}";
    hash = "sha256-4kFh2Gh3XQOVHzZJCvGNE2eacvBGuhiCw+7Rid/fIT4=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git show --format='%h' HEAD --quiet > ldflags_revision
      date --utc --date="@$(git show --format='%ct' HEAD --quiet)" +'%Y-%m-%dT%H:%M:%SZ' > ldflags_buildDate
      find . -type d -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-29u6OFErZXI/oWLJIB4oyvr+hNMQPKREtm2OlnyL+6Y=";

  # Add version information fetched from the repository to ldflags.
  ldflags = [
    "-X main.version=v${version}"
  ];
  preBuild = ''
    ldflags+=" -X main.revision=$(cat ldflags_revision)"
    ldflags+=" -X main.buildDate=$(cat ldflags_buildDate)"
  '';

  meta = {
    description = "Expose HTTP applications to a Tailscale Tailnet network";
    homepage = "https://github.com/shayne/tsnet-serve";
    changelog = "https://github.com/shayne/tsnet-serve/releases/tag/${src.tag}";
    mainProgram = "tsnet-serve";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ananthb ];
  };
}
