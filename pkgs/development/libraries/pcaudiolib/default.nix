{ config, stdenv, lib, fetchFromGitHub
, autoconf, automake, which, libtool, pkgconfig
, portaudio, alsaLib
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "pcaudiolib";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "rhdunn";
    repo = "pcaudiolib";
    rev = "${version}";
    sha256 = "0c55hlqqh0m7bcb3nlgv1s4a22s5bgczr1cakjh3767rjb10khi0";
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
