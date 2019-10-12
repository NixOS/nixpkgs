{ stdenv, fetchFromGitHub, python, cunit, dpdk, libaio, libuuid, numactl, openssl }:

stdenv.mkDerivation rec {
  pname = "spdk";
  version = "19.04";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    rev = "v${version}";
    sha256 = "10mzal1hspnh26ws5d7sc54gyjfzkf6amr0gkd7b368ng2a9z8s6";
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
    homepage = "https://spdk.io/";
    license = licenses.bsd3;
    platforms =  [ "x86_64-linux" ];
    maintainers = with maintainers; [ orivej ];
  };
}
