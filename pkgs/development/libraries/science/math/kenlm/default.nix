{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, zlib
, bzip2
, lzma
, eigen
}:

stdenv.mkDerivation rec {
  pname = "kenlm";
  version = "unstable-2022-07-03";

  src = fetchFromGitHub {
    owner = "kpu";
    repo = "kenlm";
    # repo has no tags. use latest commit
    rev = "bcd4af619a2fa45f5876d8855f7876cc09f663af";
    sha256 = "sha256-ZQbtexUtB/5N/Rpvw8yc80TRde7eqlsoh2aN9LtL0K8=";
  };

  # fix: Could NOT find Eigen3 (missing: Eigen3_DIR)
  # FindEigen3.cmake cannot find eigen
  postPatch = ''
    rm -v cmake/modules/FindEigen3.cmake
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    zlib
    bzip2
    lzma
    eigen
  ];

  meta = {
    homepage = "https://github.com/kpu/kenlm";
    description = "Faster and Smaller Language Model Queries";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ milahu ];
    platforms = lib.platforms.unix;
  };
}
