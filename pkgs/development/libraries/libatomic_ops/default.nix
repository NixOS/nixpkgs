{ stdenv, fetchurl, autoconf, automake, libtool, hostPlatform }:

stdenv.mkDerivation rec {
  name = "libatomic_ops-${version}";
  version = "7.6.2";

  src = fetchurl {
    urls = [
      "http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-${version}.tar.gz"
      "https://github.com/ivmai/libatomic_ops/releases/download/v${version}/libatomic_ops-${version}.tar.gz"
    ];
    sha256 ="1rif2hjscq5mh639nsnjhb90c01gnmy1sbmj6x6hsn1xmpnj95r1";
  };

  outputs = [ "out" "dev" "doc" ];

  # https://github.com/ivmai/libatomic_ops/pull/32
  patches = if hostPlatform.isRiscV then [ ./riscv.patch ] else null;

  nativeBuildInputs = stdenv.lib.optionals stdenv.isCygwin [ autoconf automake libtool ];

  preConfigure = stdenv.lib.optionalString stdenv.isCygwin ''
    sed -i -e "/libatomic_ops_gpl_la_SOURCES/a libatomic_ops_gpl_la_LIBADD = libatomic_ops.la" src/Makefile.am
    ./autogen.sh
  '';

  meta = {
    description = ''A library for semi-portable access to hardware-provided atomic memory update operations'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = with stdenv.lib.platforms; unix ++ windows;
  };
}
