{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "webtunnel";
  version = "0.0.4";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "webtunnel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-00Wq2/xuDNftXG+r95/HyEcWQSX0GaQao28CG8yIiR4=";
  };

  vendorHash = "sha256-3AAPySLAoMimXUOiy8Ctl+ghG5q+3dWRNGXHpl9nfG0=";

  meta = {
    description = "Pluggable Transport based on HTTP Upgrade(HTTPT)";
    homepage = "https://community.torproject.org/relay/setup/webtunnel/";
    maintainers = [ lib.maintainers.gbtb ];
    license = lib.licenses.mit;
  };
})
