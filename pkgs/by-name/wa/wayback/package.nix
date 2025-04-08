{
  lib,
  fetchFromGitHub,
  buildGoModule,
  chromium,
}:

buildGoModule rec {
  pname = "wayback";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "wabarc";
    repo = "wayback";
    rev = "v${version}";
    hash = "sha256-GnirEgJHgZVzxkFFVDU9795kgvMTitnH+xWd7ooNf7Y=";
  };

  vendorHash = "sha256-vk9c+U8mKwT03dHV9labvCOM2Ip1vk7AeiTleEBuNP4=";

  doCheck = false;

  buildInputs = [
    chromium
  ];

  meta = with lib; {
    description = "Archiving tool with an IM-style interface";
    homepage = "https://docs.wabarc.eu.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _2gn ];
    # binary build for darwin is possible, but it requires chromium for runtime dependency, whose build (for nix) is not supported on darwin.
    platforms = platforms.linux;
  };
}
