{ stdenv
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

let
  dpdk-compat-patch = fetchurl {
    url = "https://review.spdk.io/gerrit/plugins/gitiles/spdk/spdk/+/6acb9a58755856fb9316baf9dbbb7239dc6b9446%5E%21/?format=TEXT";
    sha256 = "18q0956fkjw19r29hp16x4pygkfv01alj9cld2wlqqyfgp41nhn0";
  };
in stdenv.mkDerivation rec {
  pname = "spdk";
  version = "20.04.1";

  src = fetchFromGitHub {
    owner = "spdk";
    repo = "spdk";
    rev = "v${version}";
    sha256 = "ApMyGamPrMalzZLbVkJlcwatiB8dOJmoxesdjkWZElk=";
  };

  patches = [
    ./spdk-dpdk-meson.patch
    # https://review.spdk.io/gerrit/c/spdk/spdk/+/3134
    (fetchpatch {
      url = "https://github.com/spdk/spdk/commit/c954b5b722c5c163774d3598458ff726c48852ab.patch";
      sha256 = "1n149hva5qxmpr0nmav10nya7zklafxi136f809clv8pag84g698";
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
    base64 -d ${dpdk-compat-patch} | patch -p1
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
