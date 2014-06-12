{ stdenv, fetchurl, autoconf, automake, libtool, libsodium, check
, pkgconfig, libopus, libvpx
, avSupport ? true }:

assert avSupport -> pkgconfig != null && libopus != null && libvpx != null;

let
  version = "63f25f86d";
  date = "20140611";
in
stdenv.mkDerivation rec {
  name = "tox-core-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/irungentoo/ProjectTox-Core/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "194fddqpv40w4yk0sqh5wlpgrm06jmxvgk5530ziahjpf1m5gcw6";
  };

  buildInputs = [
    autoconf automake libtool libsodium 
  ] ++ stdenv.lib.optional avSupport [ pkgconfig libopus libvpx ]
    ++ stdenv.lib.optional doCheck [ check ];

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
