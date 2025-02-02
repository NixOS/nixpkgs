{ lib, rustPlatform, fetchCrate, makeBinaryWrapper, rustfmt }:

rustPlatform.buildRustPackage rec {
  pname = "zbus_xmlgen";
  version = "5.0.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-H3QA1Eh1AL1CtiUykEjJ7Ltskcen8tIfbGg6jy7Xic8=";
  };

  cargoHash = "sha256-bglcui1OLp2USRpL2kOxU8fw+aLAbbDv5hrg5fxz4cQ=";

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
