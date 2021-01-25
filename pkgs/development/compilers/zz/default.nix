{ lib, rustPlatform, fetchFromGitHub, makeWrapper, z3 }:

rustPlatform.buildRustPackage rec {
  pname = "zz";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "zetzit";
    repo = "zz";
    rev = version;
    sha256 = "0kqrfm2r9wn0p2c3lcprsy03p9qhrwjs990va8qi59jp704l84ad";
  };

  nativeBuildInputs = [ makeWrapper ];

  cargoSha256 = "0yllcqxyyhwr9h0z8q84l0ms8x6jrqhpg79ik4xng6h5yf4ab0pq";

  postPatch = ''
    # remove search path entry which would reference /build
    sed -i '/env!("CARGO_MANIFEST_DIR")/d' src/lib.rs
  '';

  postInstall = ''
    mkdir -p "$out/share/zz"
    cp -r modules "$out/share/zz/"

    wrapProgram $out/bin/zz \
      --prefix PATH ":" "${lib.getBin z3}/bin" \
      --suffix ZZ_MODULE_PATHS ":" "$out/share/zz/modules"
  '';

  meta = with lib; {
    description = "🍺🐙 ZetZ a zymbolic verifier and tranzpiler to bare metal C";
    homepage = "https://github.com/zetzit/zz";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
