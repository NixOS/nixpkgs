{ cargo, fetchFromGitHub, makeWrapper, pkgconfig, rustPlatform, stdenv, zeromq }:

rustPlatform.buildRustPackage rec {
  name = "evcxr-${version}";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "ae07ccf08723b7aec0de57d540822b89088ca036";
    sha256 = "1apc93z9vvf6qks5x2pad45rnrj9kjl812rj78w5zmmizccp2fhf";
  };

  cargoSha256 = "1pvw1jfi4p0cla4xxzgxh1jskvbmsyi4l5cimiis7093hyjs0svw";
  cargoPatches = [ ./cargo-lock.patch ];

  nativeBuildInputs = [ pkgconfig zeromq ];
  buildInputs = [ cargo makeWrapper ];
  postInstall = "wrapProgram $out/bin/evcxr --prefix PATH : ${cargo}/bin";

  meta = {
    description = "An evaluation context for Rust, including a CLI REPL and a Jupyter kernel";
    homepage = "https://github.com/google/evcxr";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.protoben ];
    platforms = stdenv.lib.platforms.all;
  };
}
