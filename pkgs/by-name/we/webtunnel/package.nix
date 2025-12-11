{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "webtunnel";
  version = "0.0.3";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "webtunnel";
    rev = "v${version}";
    hash = "sha256-HB95GCIJeO5fKUW23VHrtNZdc9x9fk2vnmI9JogDWSQ=";
  };

  vendorHash = "sha256-3AAPySLAoMimXUOiy8Ctl+ghG5q+3dWRNGXHpl9nfG0=";

  meta = {
    description = "Pluggable Transport based on HTTP Upgrade(HTTPT)";
    homepage = "https://community.torproject.org/relay/setup/webtunnel/";
    maintainers = [ lib.maintainers.gbtb ];
    license = lib.licenses.mit;
  };
}
