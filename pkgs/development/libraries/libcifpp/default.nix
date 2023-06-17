{ lib, stdenv, fetchFromGitHub, boost, cmake, zlib }:

stdenv.mkDerivation rec {
  pname = "libcifpp";
  version = "5.0.8";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KJGcopGhCWSl+ElG3BPJjBf/kvYJowOHxto6Ci1IMco=";
  };

  nativeBuildInputs = [ cmake ];

  # disable network access
  cmakeFlags = [ "-DCIFPP_DOWNLOAD_CCD=OFF" ];

  buildInputs = [ boost zlib ];

  meta = with lib; {
    description = "Manipulate mmCIF and PDB files";
    homepage = "https://github.com/PDB-REDO/libcifpp";
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
}
