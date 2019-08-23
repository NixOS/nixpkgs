{ cargo, fetchFromGitHub, makeWrapper, pkgconfig, rustPlatform, stdenv, gcc, Security }:

rustPlatform.buildRustPackage rec {
  name = "evcxr-${version}";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "ae07ccf08723b7aec0de57d540822b89088ca036";
    sha256 = "1apc93z9vvf6qks5x2pad45rnrj9kjl812rj78w5zmmizccp2fhf";
  };

  cargoSha256 = "153pxqj4jhlbacr7607q9yfw6h96ns5igbvssis8j3gn0xp6ssg6";
  cargoPatches = [ ./cargo-lock.patch ];

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ cargo ] ++ stdenv.lib.optional stdenv.isDarwin Security;
  postInstall = ''
    wrapProgram $out/bin/evcxr --prefix PATH : ${stdenv.lib.makeBinPath [ cargo gcc ]}
    rm $out/bin/testing_runtime
  '';

  meta = {
    description = "An evaluation context for Rust";
    homepage = "https://github.com/google/evcxr";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.protoben ];
    platforms = stdenv.lib.platforms.all;
  };
}
