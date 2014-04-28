{ stdenv, fetchgit, autoconf, automake, libtool, libsodium }:

let
  date = "20140611";
  rev  = "63f25f86d38542c989898680ee091f7eb2306353";
in
stdenv.mkDerivation {
  name = "tox-${date}-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    url = git://github.com/irungentoo/ProjectTox-Core.git;
    inherit rev;
    sha256 = "0vk0x3yapssn6vvq12dbmz4b8b8v8xjqiyqf9lvr17wcgc28fm5d";
  };

  buildInputs = [ autoconf automake libtool libsodium ];

  preConfigure = "./autogen.sh";

  meta = {
    description = "Secure messaging library";
    license = stdenv.lib.licenses.gpl3;
    homepage = http://tox.im;
    maintainers = [ stdenv.lib.maintainers.emery ];
  };
}