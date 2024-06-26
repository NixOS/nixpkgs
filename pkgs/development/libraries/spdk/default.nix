{ lib, stdenv
, fetchFromGitHub
, ncurses
, python3
, cunit
, dpdk
, fuse3
, libaio
, libbsd
, libuuid
, numactl
, openssl
, pkg-config
, zlib
, zstd
, libpcap
, libnl
, elfutils
, jansson
, ensureNewerSourcesForZipFilesHook
}:

stdenv.mkDerivation rec {
  pname = "spdk";

  version = "24.05";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    rev = "v${version}";
    sha256 = "sha256-kjZWaarvNSYXseJ/uH7Ak7DbWEgrLnAwXcL8byJ9fjU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    python3
    python3.pkgs.pip
    python3.pkgs.setuptools
    python3.pkgs.wheel
    python3.pkgs.wrapPython
    pkg-config
    ensureNewerSourcesForZipFilesHook
  ];

  buildInputs = [
    cunit
    dpdk
    fuse3
    jansson
    libaio
    libbsd
    elfutils
    libuuid
    libpcap
    libnl
    numactl
    openssl
    ncurses
    zlib
    zstd
  ];

  propagatedBuildInputs = [
    python3.pkgs.configshell
  ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  configureFlags = [
    "--with-dpdk=${dpdk}"
  ];

  postCheck = ''
    python3 -m spdk
  '';

  postFixup = ''
    wrapPythonPrograms
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
