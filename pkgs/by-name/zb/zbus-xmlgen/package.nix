{ lib, rustPlatform, fetchCrate, makeBinaryWrapper, rustfmt }:

rustPlatform.buildRustPackage rec {
  pname = "zbus_xmlgen";
  version = "5.0.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-of+/HA8u+/hRnzXZqlQzL+6A4Hkka7pN+Wl2YdrACQY=";
  };

  cargoHash = "sha256-+nTXAyBelqP0HQnJ6aGFiX2NobJ/MwEav/3gDry9y2U=";

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
