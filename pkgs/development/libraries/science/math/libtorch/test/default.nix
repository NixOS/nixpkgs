{ stdenv, cmake, libtorch-bin, symlinkJoin }:

stdenv.mkDerivation {
  pname = "libtorch-test";
  version = libtorch-bin.version;

  src = ./.;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libtorch-bin ];

  doCheck = true;

  installPhase = ''
    touch $out
  '';

  checkPhase = ''
    ./test
  '';
}
