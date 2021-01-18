{ stdenv, pkg-config, mkl }:

stdenv.mkDerivation {
  pname = "mkl-test";
  version = mkl.version;

  src = ./.;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ mkl ];

  doCheck = true;

  buildPhase = ''
    # Check regular Nix build.
    gcc $(pkg-config --cflags --libs mkl-dynamic-ilp64-seq) test.c -o test

    # Clear flags to ensure that we are purely relying on options
    # provided by pkg-config.
    NIX_CFLAGS_COMPILE="" \
    NIX_LDFLAGS="" \
      gcc $(pkg-config --cflags --libs mkl-dynamic-ilp64-seq) test.c -o test
  '';

  installPhase = ''
    touch $out
  '';

  checkPhase = ''
    ./test
  '';
}
