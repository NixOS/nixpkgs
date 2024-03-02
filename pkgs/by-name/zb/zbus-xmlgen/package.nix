{ lib, rustPlatform, fetchCrate, makeBinaryWrapper, rustfmt }:

rustPlatform.buildRustPackage rec {
  pname = "zbus_xmlgen";
  version = "4.0.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-GkNxlfwLIBfAAcwQnwJHjcviB8tiNVNDZNDib1FQcvs=";
  };

  cargoHash = "sha256-dKoxLEdLZ8B8kTJj3tHcFJzY/Rv3NvwmZBAmHyNhOg8=";

  nativeBuildInputs = [ makeBinaryWrapper ];
  nativeCheckInputs = [ rustfmt ];

  postInstall = ''
    wrapProgram $out/bin/zbus-xmlgen \
        --prefix PATH : ${lib.makeBinPath [ rustfmt ]}
  '';

  meta = with lib; {
    homepage = "https://crates.io/crates/zbus_xmlgen";
    description = "D-Bus XML interface Rust code generator";
    mainProgram = "zbus-xmlgen";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
  };
}
