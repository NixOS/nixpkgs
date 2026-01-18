{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.15";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-78G0Dm0WAEjjud+vrl7n3Uh6NnMQhs3uY4DIeSTKTJs=";
  };

  cargoHash = "sha256-2CeaDoDl8QyDXN8FHfHm6WRsJOfRiq6yRCKHsXXUV0w=";

  meta = {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "vopono";
  };
}
