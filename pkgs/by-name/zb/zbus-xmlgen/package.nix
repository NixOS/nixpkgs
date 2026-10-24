{
  lib,
  rustPlatform,
  fetchCrate,
  makeBinaryWrapper,
  rustfmt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zbus_xmlgen";
  version = "6.0.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-duCq73MYnL0kUR0S07HDfcnBVQ/1veUx1mW3THfLqQg=";
  };

  cargoHash = "sha256-+dvzsSBM/Oiy0LGkAhtUOT+gazq/V3ZO4GzYPgZCU2E=";

  nativeBuildInputs = [ makeBinaryWrapper ];
  nativeCheckInputs = [ rustfmt ];

  postInstall = ''
    wrapProgram $out/bin/zbus-xmlgen \
        --prefix PATH : ${lib.makeBinPath [ rustfmt ]}
  '';

  meta = {
    homepage = "https://crates.io/crates/zbus_xmlgen";
    description = "D-Bus XML interface Rust code generator";
    mainProgram = "zbus-xmlgen";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.mit;
  };
})
