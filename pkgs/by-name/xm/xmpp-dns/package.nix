{
  lib,
  buildGoModule,
  fetchFromGitLab,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "xmpp-dns";
  version = "0.6.3";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "mdosch";
    repo = "xmpp-dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GLTAV8LtOtgYwb261m3gq+AwFQspFUjVl4Si/A5ZmzI=";
  };
  vendorHash = "sha256-KFDnFD6g88zIRt08aL/0Obik70oELCDb7piKZaSXGY4=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = "installManPage man/xmpp-dns.1";

  meta = {
    description = "CLI tool to check XMPP SRV records";
    homepage = "https://salsa.debian.org/mdosch/xmpp-dns";
    changelog = "https://salsa.debian.org/mdosch/xmpp-dns/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ haansn08 ];
    platforms = lib.platforms.all;
    mainProgram = "xmpp-dns";
  };
})
