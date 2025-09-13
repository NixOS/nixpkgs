{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
}:

buildTeleport rec {
  version = "18.2.1";
  hash = "sha256-Lvm2Eui8zlQUeopQduHO0D5TSReCt2JJZczF4xenY34=";
  vendorHash = "sha256-w8RhvTKNhHKkwvsi6S3m0S9ZSxEO9bw/qhTHlB80lHc=";
  pnpmHash = "sha256-cpkV+B50JdhcXdI/K7cqJI6TsvGOCRxkFTJcA4wE5iQ=";
  cargoHash = "sha256-ia4We4IfIkqz82aFMVvXdzjDXw0w+OJSPVdutfau6PA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
}
