{ cargo, fetchFromGitHub, makeWrapper, pkgconfig, rustPlatform, stdenv, gcc, Security, cmake }:

rustPlatform.buildRustPackage rec {
  pname = "evcxr";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "v${version}";
    sha256 = "144xqi19d2nj9qgmhpx6d1kfhx9vfkmk7rnq6nzybpx4mbbl3ki2";
  };

  cargoSha256 = "0p8qqjmynzhwp9k0rh2clng68i2sqaln6mkrd31cs5724igm4y6s";

  nativeBuildInputs = [ pkgconfig makeWrapper cmake ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;
  postInstall = ''
    wrapProgram $out/bin/evcxr --prefix PATH : ${stdenv.lib.makeBinPath [ cargo gcc ]}
    rm $out/bin/testing_runtime
  '';

  meta = with stdenv.lib; {
    description = "An evaluation context for Rust";
    homepage = "https://github.com/google/evcxr";
    license = licenses.asl20;
    maintainers = with maintainers; [ protoben ma27 ];
    platforms = platforms.all;
  };
}
