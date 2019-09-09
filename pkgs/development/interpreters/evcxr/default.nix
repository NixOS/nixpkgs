{ cargo, fetchFromGitHub, makeWrapper, pkgconfig, rustPlatform, stdenv, gcc, Security, zeromq }:

rustPlatform.buildRustPackage rec {
  pname = "evcxr";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "v${version}";
    sha256 = "1j2vsqgljqw7415rgjlnc1w3nmr9ghizx2mncbm1yipwj8xbrmf6";
  };

  cargoSha256 = "0ckxpmi547y7q4w287znimpxgaj3mjkgmkcs2n9cp4m8cw143hly";

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
