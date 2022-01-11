{ lib, stdenv
, fetchpatch
, fetchFromGitHub
, ncurses
, python3
, cunit
, dpdk
, libaio
, libbsd
, libuuid
, numactl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "spdk";
  version = "21.10";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    rev = "v${version}";
    sha256 = "sha256-pFynTbbSF1g58VD9bOhe3c4oCozeqE+35kECTQwDBDM=";
  };

  patches = [
    # Backport of upstream patch for ncurses-6.3 support.
    # Will be in next release after 21.10.
    ./ncurses-6.3.patch

    # DPDK 21.11 compatibility.
    (fetchpatch {
      url = "https://github.com/spdk/spdk/commit/f72cab94dd35d7b45ec5a4f35967adf3184ca616.patch";
      sha256 = "sha256-sSetvyNjlM/hSOUsUO3/dmPzAliVcteNDvy34yM5d4A=";
    })
  ];

  nativeBuildInputs = [
    python3
  ];

  buildInputs = [
    cunit dpdk libaio libbsd libuuid numactl openssl ncurses
  ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  configureFlags = [ "--with-dpdk=${dpdk}" ];

  NIX_CFLAGS_COMPILE = "-mssse3"; # Necessary to compile.
  # otherwise does not find strncpy when compiling
  NIX_LDFLAGS = "-lbsd";

  meta = with lib; {
    description = "Set of libraries for fast user-mode storage";
    homepage = "https://spdk.io/";
    license = licenses.bsd3;
    platforms =  [ "x86_64-linux" ];
    maintainers = with maintainers; [ orivej ];
  };
}
