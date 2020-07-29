{ cargo, fetchFromGitHub, makeWrapper, pkgconfig, rustPlatform, stdenv, gcc, Security, cmake }:

rustPlatform.buildRustPackage rec {
  pname = "evcxr";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "v${version}";
    sha256 = "09xziv2vmjd30yy095l3n33v9vdkbbkyjdcc5azyd76m2fk9vi42";
  };

  cargoSha256 = "1cdj5qh3z4bnz2267s83chw6n1kg9zl1hrawkis5rr9vq7llrb24";

  nativeBuildInputs = [ pkgconfig makeWrapper cmake ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;
  postInstall = ''
    wrapProgram $out/bin/evcxr --prefix PATH : ${stdenv.lib.makeBinPath [ cargo gcc ]}
    wrapProgram $out/bin/evcxr_jupyter --prefix PATH : ${stdenv.lib.makeBinPath [ cargo gcc ]}
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
