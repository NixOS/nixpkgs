{ stdenv, fetchsvn, alsaLib, pkgconfig }:

stdenv.mkDerivation rec {
  revision = "1788";
  name = "portaudio-svn-r${revision}";

  src = fetchsvn {
    url = "https://subversion.assembla.com/svn/portaudio/portaudio/trunk";
    rev = revision;
    sha256 = "0vhiy4lkmv0flhvkbbra71z5cfr3gbh27bbfcqqdc939b4z35lsi";
  };

  buildInputs = [ alsaLib pkgconfig ];

  meta = {
    description = "Portable cross-platform Audio API";
    homepage = http://www.portaudio.com/;
    # Not exactly a bsd license, but alike
    license = "BSD";
  };

  passthru = {
    api_version = 19;
  };
}
