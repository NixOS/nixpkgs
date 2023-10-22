{ lib
, stdenv
, boost
, cmake
, fetchFromGitHub
, fetchpatch
, eigen
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcifpp";
  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "libcifpp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-+OVfMXkBALT8v/30JU8v2gTsw12FM5n1I2COV/b5vGY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # disable network access
    "-DCIFPP_DOWNLOAD_CCD=OFF"
  ];

  buildInputs = [
    boost
    eigen
    zlib
  ];

  meta = with lib; {
    description = "Manipulate mmCIF and PDB files";
    homepage = "https://github.com/PDB-REDO/libcifpp";
    changelog = "https://github.com/PDB-REDO/libcifpp/releases/tag/${finalAttrs.src.rev}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
