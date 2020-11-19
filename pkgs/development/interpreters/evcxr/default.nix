{ cargo, fetchFromGitHub, makeWrapper, pkgconfig, rustPlatform, stdenv, gcc, Security, cmake }:

rustPlatform.buildRustPackage rec {
  pname = "evcxr";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "v${version}";
    sha256 = "sha256-QpUhUE65/IuT/VenziPX6z+CbJswbPPIv/ZnTthZpEU=";
  };

  cargoSha256 = "sha256-iUzVd4XtD+41yTV/BmqWLenzAUNPfS7vIHm1KfuPe9A=";

  RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";

  nativeBuildInputs = [ pkgconfig makeWrapper cmake ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;
  postInstall = let
    wrap = exe: ''
      wrapProgram $out/bin/${exe} \
        --prefix PATH : ${stdenv.lib.makeBinPath [ cargo gcc ]} \
        --set-default RUST_SRC_PATH "$RUST_SRC_PATH"
    '';
  in ''
    ${wrap "evcxr"}
    ${wrap "evcxr_jupyter"}
    rm $out/bin/testing_runtime
  '';

  meta = with stdenv.lib; {
    description = "An evaluation context for Rust";
    homepage = "https://github.com/google/evcxr";
    license = licenses.asl20;
    maintainers = with maintainers; [ protoben ma27 ];
  };
}
