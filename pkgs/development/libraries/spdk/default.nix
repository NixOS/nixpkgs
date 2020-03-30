{ stdenv, fetchFromGitHub, python, cunit, dpdk, libaio, libbsd, libuuid, numactl, openssl }:

stdenv.mkDerivation rec {
  pname = "spdk";
  version = "20.01.1";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    rev = "v${version}";
    sha256 = "1ci0kj0bv5jp5yipa8g0q0ah71qv6pjvvban1ad0v24f7lq4xh0w";
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
