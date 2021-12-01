{ lib, stdenv
, fetchurl
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
  version = "21.07";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    rev = "v${version}";
    sha256 = "sha256-/hynuYVdzIfiHUUfuuOY8SBJ18DqJr2Fos2JjQQVvbg=";
  };

  patches = [
    # Backport of upstream patch for ncurses-6.3 support.
    # Will be in next release after 21.10.
    ./ncurses-6.3.patch
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
