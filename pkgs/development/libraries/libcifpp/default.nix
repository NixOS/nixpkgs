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
  version = "5.1.0.1";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "libcifpp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-fAH7FIgJuitPUoacLnLs8uf9di5iM0c/2WHZqVjJOUE=";
  };

  patches = [
    (fetchpatch {
      name = "add-include-compare.patch";
      url = "https://github.com/PDB-REDO/libcifpp/commit/676c0c8dc87437e2096718fd8c0750b995e174ba.patch";
      hash = "sha256-fbA4fgiTY93+hFct+BQuHF7uv2nG7D9PljQxq1CkReU=";
    })
  ];

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
