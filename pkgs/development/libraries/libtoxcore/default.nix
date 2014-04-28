{ stdenv, fetchurl, autoconf, automake, libtool, libsodium }:

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

  preConfigure = "./autogen.sh";

  buildInputs = [ autoconf automake libtool libsodium ];

  meta = {
    description = "P2P FOSS instant messaging library aimed to replace Skype with crypto";
    homepage = http://tox.im;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ viric emery ];
    platforms = stdenv.lib.platforms.all;
  };
}
