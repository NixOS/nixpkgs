{
  lib,
  fetchFromGitHub,
  buildGoModule,
  chromium,
}:

buildGoModule (finalAttrs: {
  pname = "wayback";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "wabarc";
    repo = "wayback";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+QtO12wyWjMNbPUFaUIhozJgdYOUDclqcdRaMnMjxpI=";
  };

  vendorHash = "sha256-bygzgh20xgNGWl93Mj+g+7P9Vko96HGGXObFw1tDZ5s=";

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
