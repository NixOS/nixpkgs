{ stdenv
, pkg-config
, mkl

, enableStatic ? false
, execution ? "seq"
}:

let
  linkType = if enableStatic then "static" else "dynamic";
in stdenv.mkDerivation {
  pname = "mkl-test";
  version = mkl.version;

  unpackPhase = ''
    cp ${./test.c} test.c
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ (mkl.override { inherit enableStatic; }) ];

  doCheck = true;

  buildPhase = ''
    # Check regular Nix build.
    gcc test.c -o test $(pkg-config --cflags --libs mkl-${linkType}-ilp64-${execution})

    # Clear flags to ensure that we are purely relying on options
    # provided by pkg-config.
    NIX_CFLAGS_COMPILE="" \
    NIX_LDFLAGS="" \
      gcc test.c -o test $(pkg-config --cflags --libs mkl-${linkType}-ilp64-${execution})
  '';

  installPhase = ''
    touch $out
  '';

  checkPhase = ''
    ./test
  '';
}
