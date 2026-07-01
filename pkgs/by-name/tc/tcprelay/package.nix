{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "tcprelay";
  version = "0.1.3";

  src = fetchFromGitLab {
    owner = "overhead";
    repo = "tcp-relay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-57Ca5GrXUXF8PFTPChzoxRL/JsfawsZem5mJtude17w=";
  };

  vendorHash = null;
  __structuredAttrs = true;

  meta = {
    description = "TCP traffic relay written in Go";
    homepage = "https://gitlab.com/overhead/tcp-relay";
    changelog = "https://gitlab.com/overhead/tcp-relay/-/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shutdaun ];
    mainProgram = "tcp-relay";
    platforms = lib.platforms.linux;
  };
})
