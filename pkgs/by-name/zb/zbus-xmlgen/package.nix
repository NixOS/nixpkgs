{ lib, rustPlatform, fetchCrate, makeBinaryWrapper, rustfmt }:

rustPlatform.buildRustPackage rec {
  pname = "zbus_xmlgen";
  version = "4.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-71HxHfUTRmm4BpBz1lGbcvOpbwNQ/wCa5EKCSM1YEtQ=";
  };

  cargoHash = "sha256-ADS68qTYO/aDwg4MS4v8t25i9vNx8Je37O7icR3tID8=";

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
