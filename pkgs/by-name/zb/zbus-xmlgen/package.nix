{
  lib,
  rustPlatform,
  fetchCrate,
  makeBinaryWrapper,
  rustfmt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zbus_xmlgen";
  version = "5.3.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-lFgYGzc0+VIwiXZrKKc+cVwj2U8Y1mg4BMIuG0S/8+g=";
  };

  cargoHash = "sha256-//0cJF47E58tkubXRrJcUcqHkhzp3zdshxj9VQ5Zrgw=";

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
