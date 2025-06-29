{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tsnet-serve";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "shayne";
    repo = "tsnet-serve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4kFh2Gh3XQOVHzZJCvGNE2eacvBGuhiCw+7Rid/fIT4=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out show --format='%h' HEAD --quiet > $out/ldflags_revision
      date --utc --date="@$(git -C $out show --format='%ct' HEAD --quiet)" +'%Y-%m-%dT%H:%M:%SZ' > $out/ldflags_buildDate
      rm -rf $out/.git
    '';
  };

  vendorHash = "sha256-29u6OFErZXI/oWLJIB4oyvr+hNMQPKREtm2OlnyL+6Y=";

  # Add version information fetched from the repository to ldflags.
  ldflags = [
    "-X main.version=v${finalAttrs.version}"
  ];
  preBuild = ''
    ldflags+=" -X main.revision=$(cat ldflags_revision)"
    ldflags+=" -X main.buildDate=$(cat ldflags_buildDate)"
  '';

  meta = {
    description = "Expose HTTP applications to a Tailscale Tailnet network";
    homepage = "https://github.com/shayne/tsnet-serve";
    changelog = "https://github.com/shayne/tsnet-serve/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "tsnet-serve";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ananthb ];
  };
})
