{ lib, stdenv, fetchFromGitHub, boost, cmake, }:

stdenv.mkDerivation rec {
  pname = "libcifpp";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mhplcpni4p8lavrq4fz9qq8mbxhvpnlxzy55yrz8y07d76ajg6y";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ];

  meta = with lib; {
    description = "Manipulate mmCIF and PDB files";
    homepage = "https://github.com/PDB-REDO/libcifpp";
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
}
