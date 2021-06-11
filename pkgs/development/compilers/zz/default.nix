{ lib, rustPlatform, fetchFromGitHub, makeWrapper, z3 }:

rustPlatform.buildRustPackage rec {
  pname = "zz";
  version = "unstable-2021-03-07";

  # when updating, choose commit of the latest build on http://bin.zetz.it/
  src = fetchFromGitHub {
    owner = "zetzit";
    repo = "zz";
    rev = "d3fc968ba2ae6668f930e39077f9a90aecb9fdc4";
    sha256 = "18p17lgwq6rq1n76sj0dwb32bpxflfd7knky1v0sgmaxfpaq04y3";
  };

  nativeBuildInputs = [ makeWrapper ];

  cargoSha256 = "03xdmm4993hqdb3cihjjv4n4mdk8lnlccva08fh6m1d56p807rni";

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
    description = "ZetZ a zymbolic verifier and tranzpiler to bare metal C";
    homepage = "https://github.com/zetzit/zz";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
