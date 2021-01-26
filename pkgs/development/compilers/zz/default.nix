{ lib, rustPlatform, fetchFromGitHub, makeWrapper, z3 }:

rustPlatform.buildRustPackage rec {
  pname = "zz";
  version = "unstable-2021-01-26";

  # commit chosen by using the latest build from http://bin.zetz.it/
  src = fetchFromGitHub {
    owner = "aep";
    repo = "zz";
    rev = "0b5c52674e9adf795fbfb051d4dceef3126e669f";
    sha256 = "0bb77ll1g5i6a04ybpgx6lqsb74xs4v4nyqm9j4j6x24407h8l89";
  };

  nativeBuildInputs = [ makeWrapper ];

  cargoSha256 = "1lf4k3n89w2797c1yrj1dp97y8a8d5hnixr1nwa2qcq1sxmm5rcg";

  postInstall = ''
    wrapProgram $out/bin/zz --prefix PATH ":" "${lib.getBin z3}/bin"
  '';

  meta = with lib; {
    description = "🍺🐙 ZetZ a zymbolic verifier and tranzpiler to bare metal C";
    homepage = "https://github.com/aep/zz";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
