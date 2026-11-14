{
  lib,
  rustPlatform,
  fetchCrate,
  makeBinaryWrapper,
  rustfmt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zbus_xmlgen";
  version = "5.4.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-jfK+p5+DoxeGzzti984OZx527xiETtKuWQfLBnXrIAk=";
  };

  cargoHash = "sha256-fnUlEPf/0rd4unjoLRg+HTHwDkC0CkIL+UnRy8/56w0=";

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
