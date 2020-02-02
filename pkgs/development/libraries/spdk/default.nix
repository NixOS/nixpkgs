{ stdenv, fetchFromGitHub, python, cunit, dpdk, libaio, libbsd, libuuid, numactl, openssl }:

stdenv.mkDerivation rec {
  pname = "spdk";
  version = "19.10.1";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    rev = "v${version}";
    sha256 = "1fajcc4c09p6wcfw08k0x4x7v8yh0ghq94zhs5d4g9563p2va6ab";
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
