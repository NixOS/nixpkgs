{ stdenv, fetchFromGitHub, python, cunit, dpdk, libaio, libbsd, libuuid, numactl, openssl }:

stdenv.mkDerivation rec {
  pname = "spdk";
  version = "20.01";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    rev = "v${version}";
    sha256 = "13pbl46bfzc3z10ydr1crimklyj7f0s73873bjknglw474gm52h8";
  };

  patches = [ ./spdk-dpdk-meson.patch ];

  nativeBuildInputs = [ python ];

  buildInputs = [ cunit dpdk libaio libbsd libuuid numactl openssl ];

  postPatch = ''
    patchShebangs .
  '';

  configureFlags = [ "--with-dpdk=${dpdk}" ];

  NIX_CFLAGS_COMPILE = "-mssse3"; # Necessary to compile.

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Set of libraries for fast user-mode storage";
    homepage = "https://spdk.io/";
    license = licenses.bsd3;
    platforms =  [ "x86_64-linux" ];
    maintainers = with maintainers; [ orivej ];
  };
}
