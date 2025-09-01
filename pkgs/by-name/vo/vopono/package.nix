{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.14";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-EfbRSQtJA2ktpFzWnJWbUFLajdpaDdbpKeOykrorl2Q=";
  };

  cargoHash = "sha256-j7KFlFaxgXvrEzuknBTzfYgU1S57YhvVXkP73u888rc=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
    mainProgram = "vopono";
  };
}
