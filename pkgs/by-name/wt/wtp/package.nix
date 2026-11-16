{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
}:

buildGoModule (finalAttrs: {
  pname = "wtp";
  version = "2.10.4";

  src = fetchFromGitHub {
    owner = "satococoa";
    repo = "wtp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WayM3a9cCKWaEeo4y2cqYTMFjzUr3vaWis70OPKj8LE=";
  };

  vendorHash = "sha256-zsSNo1MQgpvH3ZSd3kmvdIpOCVJgSu1/pYLltx/9dZg=";

  subPackages = [ "cmd/wtp" ];
  __structuredAttrs = true;

  nativeCheckInputs = [ gitMinimal ];

  preCheck = ''
    git init .
    git config user.name "nixpkgs"
    git config user.email "nixpkgs@example.invalid"
    touch .nixpkgs-wtp-test
    git add .nixpkgs-wtp-test
    git commit -m "Init test repo" >/dev/null
  '';

  meta = {
    description = "Git worktree CLI with automated setup, branch tracking, and navigation";
    homepage = "https://github.com/satococoa/wtp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jsqu4re ];
    mainProgram = "wtp";
  };
})
