{
  lib,
  rustPlatform,
  fetchCrate,
  makeBinaryWrapper,
  rustfmt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zbus_xmlgen";
  version = "5.3.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-STwci4PaleJc7TBK1dth2uHuXEVb1wDOSWOV+8RznmU=";
  };

  cargoHash = "sha256-w5l6cUIA8vZmChLzjDF7UVf/ExeLnzo+Yd24LzAd+ss=";

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
