{
  buildGoModule,
  fetchFromGitHub,
  lib,
  perl,
}:

buildGoModule rec {
  pname = "XD";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "majestrate";
    repo = "XD";
    rev = "v${version}";
    sha256 = "sha256-bBA2CEeijXg+9ohiMWkQWAsN7OUSyUsFbliNz8gpVMM=";
  };

  vendorHash = "sha256-Y2BPGIfIBx/AAzfWK/hjjJqXSTjjN3lxTi+7+66taIY=";

  nativeCheckInputs = [ perl ];

  postInstall = ''
    ln -s $out/bin/XD $out/bin/XD-CLI
  '';

  meta = with lib; {
    description = "i2p bittorrent client";
    homepage = "https://xd-torrent.github.io";
    maintainers = with maintainers; [ nixbitcoin ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
