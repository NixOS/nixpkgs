{ stdenv, fetchFromGitHub, python, cunit, dpdk, libaio, libuuid, numactl, openssl }:

stdenv.mkDerivation rec {
  name = "spdk-${version}";
  version = "18.04";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    rev = "v${version}";
    sha256 = "07i13jkf63h5ld9djksxl445v1mj6m5cbq4xydix9y5qcxwlss3n";
  };

  nativeBuildInputs = [ python ];

  buildInputs = [ cunit dpdk libaio libuuid numactl openssl ];

  postPatch = ''
    patchShebangs .
  '';

  configureFlags = [ "--with-dpdk=${dpdk}" ];

  NIX_CFLAGS_COMPILE = [ "-mssse3" ]; # Necessary to compile.

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Set of libraries for fast user-mode storage";
    homepage = http://www.spdk.io;
    license = licenses.bsd3;
    platforms =  [ "x86_64-linux" ];
    maintainers = with maintainers; [ orivej ];
  };
}
