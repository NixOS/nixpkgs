{ lib, stdenv, fetchurl, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "libatomic_ops";
  version = "7.6.10";

  src = fetchurl {
    urls = [
      "http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-${version}.tar.gz"
      "https://github.com/ivmai/libatomic_ops/releases/download/v${version}/libatomic_ops-${version}.tar.gz"
    ];
    sha256 = "1bwry043f62pc4mgdd37zx3fif19qyrs8f5bw7qxlmkzh5hdyzjq";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = lib.optionals stdenv.isCygwin [ autoconf automake libtool ];

  preConfigure = lib.optionalString stdenv.isCygwin ''
    sed -i -e "/libatomic_ops_gpl_la_SOURCES/a libatomic_ops_gpl_la_LIBADD = libatomic_ops.la" src/Makefile.am
    ./autogen.sh
  '';

  meta = {
    description = "A library for semi-portable access to hardware-provided atomic memory update operations";
    license = lib.licenses.gpl2Plus ;
    maintainers = [lib.maintainers.raskin];
    platforms = with lib.platforms; unix ++ windows;
  };
}
