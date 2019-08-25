{ cargo, fetchFromGitHub, makeWrapper, pkgconfig, rustPlatform, stdenv, gcc, Security, zeromq }:

rustPlatform.buildRustPackage rec {
  pname = "evcxr";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "v${version}";
    sha256 = "08zsdl6pkg6dx7k0ns8cd070v7ydsxkscd2ms8wh9r68c08vwzcp";
  };

  cargoSha256 = "1hqlagwl94xcybfqq5h2mrz9296mjns2l598d6jclls7ac5wsdfc";

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ zeromq ] ++ stdenv.lib.optional stdenv.isDarwin Security;
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
