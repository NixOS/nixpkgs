{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "webtunnel";
  version = "0.0.7";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "webtunnel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m++vVtUGwkprCMwEeRgHSww4rXGfozv62x9uZQ9pDWo=";
  };

  vendorHash = "sha256-mVvs1p63tQG7+s/5Hg4tcpCmNo/B8U5ArKqeuec5Mc4=";

  meta = {
    description = "Pluggable Transport based on HTTP Upgrade(HTTPT)";
    homepage = "https://community.torproject.org/relay/setup/webtunnel/";
    maintainers = [ lib.maintainers.gbtb ];
    license = lib.licenses.mit;
  };
})
