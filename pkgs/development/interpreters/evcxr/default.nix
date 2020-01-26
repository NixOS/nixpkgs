{ cargo, fetchFromGitHub, makeWrapper, pkgconfig, rustPlatform, stdenv, gcc, Security, cmake }:

rustPlatform.buildRustPackage rec {
  pname = "evcxr";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "239e431c58d04c641da22af791e4d3e1b894365e";
    sha256 = "0vkcis06gwsqfwvrl8xcf74mfcs6j77b9fhcz5rrh77mwl7ixsdc";
  };

  cargoSha256 = "04wffj2y9pqyk0x3y6ghp06pggmxnk2h245iabqq0mpwx36fd8b6";

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
