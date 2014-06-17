{ stdenv, fetchurl, autoconf, automake, libtool, libsodium, check
, pkgconfig, libopus, libvpx
, avSupport ? false }:

assert avSupport -> pkgconfig != null && libopus != null && libvpx != null;

stdenv.mkDerivation rec {
  rev = "881b2d900d1998981fb6b9938ec66012d049635f";
  date = "20140615";
  name = "tox-core-${date}-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchurl {
    url = "https://github.com/irungentoo/ProjectTox-Core/tarball/${rev}";
    name = "${name}.tar.gz";
    sha256 = "186a4dkl3qgxnz51qny87xhyg75741idni3c96h3a44lwps1k913";
  };

  buildInputs = [
    autoconf automake libtool
  ] ++ stdenv.lib.optional avSupport [ pkgconfig libopus libvpx ]
    ++ stdenv.lib.optional doCheck [ check ];

  propagatedBuildInputs = [
    libsodium
  ];

  preConfigure = "./autogen.sh";

  # Explicitly link against libgcc_s, to work around the infamous
  # "libgcc_s.so.1 must be installed for pthread_cancel to work".
  LDFLAGS = stdenv.lib.optionalString doCheck "-lgcc_s";
  doCheck = false;
  # important tests pass, others inevitably fail due to the build environment

  meta = {
    description = "P2P FOSS instant messaging library aimed to replace Skype with crypto";
    homepage = http://tox.im;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ viric emery ];
    platforms = stdenv.lib.platforms.all;
  };
}
