{ stdenv, fetchurl, libevent, buildEnv, autoreconfHook, rdma-core }:

let

  version = "1.9.0";

in stdenv.mkDerivation rec {
  pname = "libfabric";
  inherit version;

  src = with stdenv.lib.versions; fetchurl {
    url = "https://github.com/ofiwg/libfabric/archive/v${version}.tar.gz";
    sha256 = "0jmvvfny347sa9zbsfgmdqxrnsiq14j7kja135zym0l9d813fxdj";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = with stdenv; lib.optionals isLinux [ rdma-core ];

  configureFlags = [
    "--disable-fast-install"
# TODO: build with TrueScale/OmniPath support
#   "--enable-psm=yes"
#   "--enable-psm2=yes"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://ofiwg.github.io/libfabric/;
    description = "The Open Fabrics Interfaces (OFI) is a framework focused on exporting fabric communication services to applications.";
    maintainers = with maintainers; [ ikervagyok ];
    license = with licenses; [ bsd2 gpl2 ];
    platforms = platforms.unix;
  };
}
