{
  lib,
  rustPlatform,
  fetchCrate,
  makeBinaryWrapper,
  rustfmt,
}:

rustPlatform.buildRustPackage rec {
  pname = "zbus_xmlgen";
  version = "5.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-LHY4E2YemGksK8xJx0r3iTHnk3CqMl5abM08VSBPIfo=";
  };

  cargoHash = "sha256-g5GLyloeyVXcJgMVx21ePYlcYUj+NGFtVarpYeQN9rw=";

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
