{ stdenv, cmake, libtorch-bin, symlinkJoin }:

stdenv.mkDerivation {
  pname = "libtorch-test";
  version = libtorch-bin.version;

  src = ./.;

  postPatch = ''
    cat CMakeLists.txt
  '';

  makeFlags = [ "VERBOSE=1" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libtorch-bin ];

  installPhase = ''
    touch $out
  '';

  checkPhase = ''
    ./test
  '';
}
