{ lib, stdenv, fetchFromGitHub, boost, cmake, }:

stdenv.mkDerivation rec {
  pname = "libcifpp";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hzi6fgbsmy8h8nfwkyfds9jz13nqw72h0x81jqw5516kkvar5iw";
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
