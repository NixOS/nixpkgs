{ stdenv, fetchFromGitHub, python, cunit, dpdk, libaio, libbsd, libuuid, numactl, openssl }:

stdenv.mkDerivation rec {
  pname = "spdk";
  version = "19.10";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    rev = "v${version}";
    sha256 = "16v2vswn3rnnj7ak5w5rsak6r8f9b85gyhyll4ac1k4xpyj488hj";
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
