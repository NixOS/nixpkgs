{ lib
, stdenv
, ensureNewerSourcesForZipFilesHook
, fetchFromGitHub
, cunit
, dpdk
, elfutils
, jansson
, libaio
, libbsd
, libnl
, libpcap
, libuuid
, ncurses
, numactl
, openssl
, pkg-config
, python3
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "spdk";
  version = "23.09";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    rev = "v${version}";
    sha256 = "sha256-P10NDa+MIEY8B3bu34Dq2keyuv2a24XV5Wf+Ah701b8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    python3
    python3.pkgs.setuptools
    pkg-config
    ensureNewerSourcesForZipFilesHook
  ];

  buildInputs = [
    cunit
    dpdk
    elfutils
    jansson
    libaio
    libbsd
    libnl
    libpcap
    libuuid
    ncurses
    numactl
    openssl
    zlib
    zstd
  ];

  patches = [
    # https://review.spdk.io/gerrit/c/spdk/spdk/+/20394
    ./setuptools.patch
    ./0001-fix-setuptools-installation.patch
  ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  configureFlags = [
    "--with-dpdk=${dpdk}"
    "--pydir=${placeholder "out"}"
  ];

  postCheck = ''
    python3 -m spdk
  '';

  env.NIX_CFLAGS_COMPILE = "-mssse3"; # Necessary to compile.
  # otherwise does not find strncpy when compiling
  env.NIX_LDFLAGS = "-lbsd";

  meta = with lib; {
    description = "Set of libraries for fast user-mode storage";
    homepage = "https://spdk.io/";
    license = licenses.bsd3;
    platforms =  [ "x86_64-linux" ];
    maintainers = with maintainers; [ orivej ];
  };
}
