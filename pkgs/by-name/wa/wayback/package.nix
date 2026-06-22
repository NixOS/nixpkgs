{
  lib,
  fetchFromGitHub,
  buildGoModule,
  chromium,
}:

buildGoModule (finalAttrs: {
  pname = "wayback";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "wabarc";
    repo = "wayback";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GnirEgJHgZVzxkFFVDU9795kgvMTitnH+xWd7ooNf7Y=";
  };

  vendorHash = "sha256-vk9c+U8mKwT03dHV9labvCOM2Ip1vk7AeiTleEBuNP4=";

  doCheck = false;

  buildInputs = [
    chromium
  ];

  meta = {
    description = "Archiving tool with an IM-style interface";
    homepage = "https://docs.wabarc.eu.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ _2gn ];
    # binary build for darwin is possible, but it requires chromium for runtime dependency, whose build (for nix) is not supported on darwin.
    platforms = lib.platforms.linux;
  };
})
