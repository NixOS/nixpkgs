{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "writedisk";
  version = "1.3.0";

  src = fetchCrate {
    inherit (finalAttrs) version;
    pname = "writedisk";
    hash = "sha256-MZFnNb8rJMu/nlH8rfnD//bhqPSkhyXucbTrwsRM9OY=";
  };

  cargoHash = "sha256-2Vc0vCQJY2enwTAgaRgqLdCTtF5znrF3xaCTvF44XX0=";

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Small utility for writing a disk image to a USB drive";
    homepage = "https://github.com/nicholasbishop/writedisk";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ devhell ];
  };
})
