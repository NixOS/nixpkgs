{ lib, stdenv
, fetchurl
, fetchFromGitHub
, fetchpatch
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
  version = "21.04";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    rev = "v${version}";
    sha256 = "sha256-Xmmgojgtt1HwTqG/1ZOJVo1BcdAH0sheu40d73OJ68w=";
  };

  nativeBuildInputs = [
    python3
  ];

  buildInputs = [
    cunit dpdk libaio libbsd libuuid numactl openssl ncurses
  ];

  postPatch = ''
    patchShebangs .
  '';

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
