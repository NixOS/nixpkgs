{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.11";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-qgsfTniikrdykFSFqZATp7ewPZm5z5p5FMztNKWzPIY=";
  };

  cargoHash = "sha256-/z4qBBY/Htlv55vNKj2c1frWsUFTRweJh/G0T2jHLr4=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
    mainProgram = "vopono";
  };
}
