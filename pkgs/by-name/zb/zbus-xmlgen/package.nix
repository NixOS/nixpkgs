{
  lib,
  rustPlatform,
  fetchCrate,
  makeBinaryWrapper,
  rustfmt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zbus_xmlgen";
  version = "6.0.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-wqFiNLDq9jsbCavkQMPjoyi0ZBh7SCdKHioYdGIHmAE=";
  };

  cargoHash = "sha256-cDaUYMoPtXcakkLpoOVWLmldjWOtu4m+8VJlRO94yoA=";

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
