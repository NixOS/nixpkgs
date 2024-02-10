{ lib, rustPlatform, fetchCrate, makeBinaryWrapper, rustfmt }:

rustPlatform.buildRustPackage rec {
  pname = "zbus_xmlgen";
  version = "3.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-vaefyfasOLFFYWPjSJFgjIFkvnRiJVe/GLYUQxUYlt0=";
  };

  cargoHash = "sha256-WXJ49X4B2aNy1zPbTllIzRhZJvF+RwfQ0Hhm/D+LQfk=";

  nativeBuildInputs = [ makeBinaryWrapper ];

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
