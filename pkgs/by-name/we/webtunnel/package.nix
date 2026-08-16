{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "webtunnel";
  version = "0.0.5";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "webtunnel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9dXlkIkCERy/eFsVrAfBkbjU6aEeJLGmlLjLuXTwAs8=";
  };

  vendorHash = "sha256-3AAPySLAoMimXUOiy8Ctl+ghG5q+3dWRNGXHpl9nfG0=";

  meta = {
    description = "Pluggable Transport based on HTTP Upgrade(HTTPT)";
    homepage = "https://community.torproject.org/relay/setup/webtunnel/";
    maintainers = [ lib.maintainers.gbtb ];
    license = lib.licenses.mit;
  };
})
