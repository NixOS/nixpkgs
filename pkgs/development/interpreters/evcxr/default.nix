{ cargo, fetchFromGitHub, makeWrapper, pkg-config, rustPlatform, lib, stdenv
, gcc, cmake, libiconv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "evcxr";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "v${version}";
    sha256 = "sha256-sdvBAmINl/3Hv9gnPVruI5lCuSu1VQ9swY0GNJrsEVk=";
  };

  cargoSha256 = "sha256-wKoseZTAZOeT0LEHTlnO5cMpYx6sinnQkEVXCYXupAY=";

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
