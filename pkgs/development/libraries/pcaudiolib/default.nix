{ config, stdenv, lib, fetchFromGitHub
, autoconf, automake, which, libtool, pkg-config
, portaudio, alsa-lib
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "pcaudiolib";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "espeak-ng";
    repo = "pcaudiolib";
    rev = version;
    sha256 = "0c55hlqqh0m7bcb3nlgv1s4a22s5bgczr1cakjh3767rjb10khi0";
  };

  nativeBuildInputs = [ autoconf automake which libtool pkg-config ];

  buildInputs = [ portaudio ]
    ++ lib.optionals stdenv.isLinux [ alsa-lib ]
    ++ lib.optionals pulseaudioSupport [ libpulseaudio ];

  preConfigure = "./autogen.sh";

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Provides a C API to different audio devices";
    homepage = "https://github.com/espeak-ng/pcaudiolib";
    license = licenses.gpl3;
    maintainers = with maintainers; [ aske ];
    platforms = platforms.all;
  };
}
