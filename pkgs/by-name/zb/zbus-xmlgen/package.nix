{
  lib,
  rustPlatform,
  fetchCrate,
  makeBinaryWrapper,
  rustfmt,
}:

rustPlatform.buildRustPackage rec {
  pname = "zbus_xmlgen";
  version = "5.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-CFXOPUWjbzNkE8mb+AC4ZtdvV0MSb/eBr1C0WyreAoU=";
  };

  cargoHash = "sha256-ggKuTcsUMhfhY39i/iZj7oPrsFchRdcko1oDE+XQLfE=";

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
}
