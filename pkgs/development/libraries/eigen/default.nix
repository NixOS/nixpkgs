{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "eigen";
  version = "3.4.0";

  src = fetchFromGitLab {
    owner = "libeigen";
    repo = pname;
    rev = version;
    sha256 = "sha256-1/4xMetKMDOgZgzz3WMxfHUEpmdAm52RqZvz6i0mLEw=";
  };

  patches = [
    ./include-dir.patch

    # Fixes e.g. onnxruntime on aarch64-darwin:
    # https://hydra.nixos.org/build/248915128/nixlog/1,
    # originally suggested in https://github.com/NixOS/nixpkgs/pull/258392.
    #
    # The patch is from
    # ["Fix vectorized reductions for Eigen::half"](https://gitlab.com/libeigen/eigen/-/merge_requests/699)
    # which is two years old,
    # but Eigen hasn't had a release in two years either:
    # https://gitlab.com/libeigen/eigen/-/issues/2699.
    (fetchpatch {
      url = "https://gitlab.com/libeigen/eigen/-/commit/d0e3791b1a0e2db9edd5f1d1befdb2ac5a40efe0.patch";
      hash = "sha256-8qiNpuYehnoiGiqy0c3Mcb45pwrmc6W4rzCxoLDSvj0=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://eigen.tuxfamily.org";
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [
      sander
      raskin
    ];
    platforms = platforms.unix;
  };
}
