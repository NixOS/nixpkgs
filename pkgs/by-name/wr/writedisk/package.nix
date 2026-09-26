{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "writedisk";
  version = "1.5.0";

  src = fetchCrate {
    inherit (finalAttrs) version;
    pname = "writedisk";
    hash = "sha256-Weu2rUZYvKMQIwxDQsCW30NAjb6Dar2926r/tyREDoo=";
  };

  cargoHash = "sha256-W1IuK6/gkvfaHsivgfF0J+SisX8nPKLR7qFZ2Ia+LEc=";

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Small utility for writing a disk image to a USB drive";
    homepage = "https://github.com/nicholasbishop/writedisk";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      devhell
      lukas-sgx
    ];
  };
})
