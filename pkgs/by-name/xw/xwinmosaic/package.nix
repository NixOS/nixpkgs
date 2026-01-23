{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  gtk2,
  cmake,
  pkg-config,
  libXdamage,
}:

stdenv.mkDerivation rec {
  version = "0.4.2";
  pname = "xwinmosaic";

  src = fetchFromGitHub {
    owner = "soulthreads";
    repo = "xwinmosaic";
    tag = "v${version}";
    sha256 = "16qhrpgn84fz0q3nfvaz5sisc82zk6y7c0sbvbr69zfx5fwbs1rr";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains like upstream gcc-10:
    #  https://github.com/soulthreads/xwinmosaic/pull/33
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/soulthreads/xwinmosaic/commit/a193a3f30850327066e5a93b29316cba2735e10d.patch";
      sha256 = "0qpk802j5x6bsfvj6jqw1nz482jynwyk7yrrh4bsziwc53khm95q";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    gtk2
    libXdamage
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "X window switcher drawing a colourful grid";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    mainProgram = "xwinmosaic";
  };
}
