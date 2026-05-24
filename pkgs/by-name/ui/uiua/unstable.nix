rec {
  version = "0.19.0-dev.4";
  tag = version;
  hash = "sha256-Df/d6dCYXRG8uWVTpLR3I8llS1ujT3QFnx5TCZSxf+0=";
  cargoHash = "sha256-cXD780n7qI8baDYyOdJvFBvXV2qCTiutgLc19+ewHnk=";
  updateScript = ./update-unstable.sh;
  patches = [ ./0001-no-network-test.patch ];
}
