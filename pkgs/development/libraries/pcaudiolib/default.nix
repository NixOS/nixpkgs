{ stdenv, lib, fetchFromGitHub, autoconf, automake, which, libtool, pkgconfig,
  alsaLib, portaudio, 
  pulseaudioSupport ? true, libpulseaudio }:

stdenv.mkDerivation rec {
  name = "pcaudiolib-${version}";
  version = "2016-07-19";

  src = fetchFromGitHub {
    owner = "rhdunn";
    repo = "pcaudiolib";
    rev = "4f836ea909bdaa8a6e0e89c587efc745b546b459";
    sha256 = "0z99nh4ibb9md2cd21762n1dmv6jk988785s1cxd8lsy4hp4pwfa";
  };

  nativeBuildInputs = [ autoconf automake which libtool pkgconfig ];

  buildInputs = [ portaudio alsaLib ] ++ lib.optional pulseaudioSupport libpulseaudio;

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "Provides a C API to different audio devices";
    homepage = https://github.com/rhdunn/pcaudiolib;
    license = licenses.gpl3;
    maintainers = with maintainers; [ aske ];
    platforms = platforms.linux;
  };
}
