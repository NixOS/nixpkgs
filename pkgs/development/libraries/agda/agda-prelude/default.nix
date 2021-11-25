{ lib, mkDerivation, fetchFromGitHub }:

mkDerivation rec {
  version = "compat-2.6.2";
  pname = "agda-prelude";

  src = fetchFromGitHub {
    owner = "UlfNorell";
    repo = "agda-prelude";
    rev = version;
    sha256 = "0j2nip5fbn61fpkm3qz4dlazl4mzdv7qlgw9zm15bkcvaila0h14";
  };

  preConfigure = ''
    cd test
    make everything
    mv Everything.agda ..
    cd ..
  '';

  meta = with lib; {
    homepage = "https://github.com/UlfNorell/agda-prelude";
    description = "Programming library for Agda";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ mudri alexarice turion ];
  };
}
