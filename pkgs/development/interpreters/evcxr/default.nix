{ cargo, fetchFromGitHub, makeWrapper, pkg-config, rustPlatform, lib, stdenv
, gcc, cmake, libiconv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "evcxr";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "v${version}";
    sha256 = "sha256-89+RZrG/QUo3JY9N5eTiMigUnlUP+wZWRW8PSnCcsrY=";
  };

  cargoSha256 = "sha256-gZLSTWS5cLfJvk4/tv8FG2I2vH3PKljWbJDOflNDmTQ=";

  RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";

  nativeBuildInputs = [ pkg-config makeWrapper cmake ];
  buildInputs = lib.optionals stdenv.isDarwin
    [ libiconv CoreServices Security ];

  postInstall = let
    wrap = exe: ''
      wrapProgram $out/bin/${exe} \
        --prefix PATH : ${lib.makeBinPath [ cargo gcc ]} \
        --set-default RUST_SRC_PATH "$RUST_SRC_PATH"
    '';
  in ''
    ${wrap "evcxr"}
    ${wrap "evcxr_jupyter"}
    rm $out/bin/testing_runtime
  '';

  meta = with lib; {
    description = "An evaluation context for Rust";
    homepage = "https://github.com/google/evcxr";
    license = licenses.asl20;
    maintainers = with maintainers; [ protoben ma27 ];
  };
}
