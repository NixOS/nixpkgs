{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:
buildGoModule {
  pname = "webtunnel";
  version = "0-unstable-2024-07-06"; # package is not versioned upstream
  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "webtunnel";
    rev = "e64b1b3562f3ab50d06141ecd513a21ec74fe8c6";
    hash = "sha256-25ZtoCe1bcN6VrSzMfwzT8xSO3xw2qzE4Me3Gi4GbVs=";
  };

  vendorHash = "sha256-3AAPySLAoMimXUOiy8Ctl+ghG5q+3dWRNGXHpl9nfG0=";

  meta = {
    description = "Pluggable Transport based on HTTP Upgrade(HTTPT)";
    homepage = "https://community.torproject.org/relay/setup/webtunnel/";
    maintainers = [ lib.maintainers.gbtb ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };

}
