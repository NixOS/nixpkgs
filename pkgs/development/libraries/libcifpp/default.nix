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
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "libcifpp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-9je4oj5XvclknD14Nh0LnBONHMeO40nY0+mZ9ACQYmY=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/PDB-REDO/libcifpp/issues/51
      name = "fix-build-on-darwin.patch";
      url = "https://github.com/PDB-REDO/libcifpp/commit/641f06a7e7c0dc54af242b373820f2398f59e7ac.patch";
      hash = "sha256-eWNfp9nA/+2J6xjZR6Tj+5OM3L5MxdfRi0nBzyaqvS0=";
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
