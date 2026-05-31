{
  buildGoModule,
  fetchFromGitHub,
  lib,
  perl,
}:

buildGoModule (finalAttrs: {
  pname = "XD";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "majestrate";
    repo = "XD";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-PKmkBwVedt/PlGo7gPWrVHbv+RPsA1BczRFR+ima0ZA=";
  };

  vendorHash = "sha256-PhZZzB07BNPuBafWwvUD7pVu31awP6NkZxsO89xYPT0=";

  nativeCheckInputs = [ perl ];

  postInstall = ''
    ln -s $out/bin/XD $out/bin/XD-CLI
  '';

  meta = {
    description = "i2p bittorrent client";
    homepage = "https://xd-torrent.github.io";
    maintainers = with lib.maintainers; [ nixbitcoin ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
