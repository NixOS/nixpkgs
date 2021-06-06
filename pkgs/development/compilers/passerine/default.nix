{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "passerine";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "vrtbl";
    repo = "passerine";
    rev = "dd8a6f5efc5dcb03d45b102f61cc8a50d46e8e98";
    sha256 = "sha256-/QzqKLkxAVqvTY4Uft1qk7nJat6nozykB/4X1YGqu/I=";
  };

  cargoSha256 = "sha256-8WiiDLIJ/abXELF8S+4s+BPA/Lr/rpKmC1NWPCLzQWA=";

  meta = with lib; {
    description = "A small extensible programming language designed for concise expression with little code";
    homepage = "https://github.com/vrtbl/passerine";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
