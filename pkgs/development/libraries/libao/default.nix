{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig, libpulseaudio, alsaLib, libcap
, CoreAudio, CoreServices, AudioUnit
, usePulseAudio }:

stdenv.mkDerivation rec {
  version = "1.2.2";
  pname = "libao";

  # the github mirror is more up to date than downloads.xiph.org
  src = fetchFromGitHub {
    owner  = "xiph";
    repo   = "libao";
    rev    = version;
    sha256 = "0svgk4sc9kdhcsfyvbvgm5vpbg3sfr6z5rliflrw49v3x2i4vxq5";
  };

  configureFlags = [
    "--disable-broken-oss"
    "--enable-alsa-mmap"
  ];

  outputs = [ "out" "dev" "man" "doc" ];

  buildInputs = [ ] ++
    lib.optional  usePulseAudio   libpulseaudio ++
    lib.optionals stdenv.isLinux  [ alsaLib libcap ] ++
    lib.optionals stdenv.isDarwin [ CoreAudio CoreServices AudioUnit ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  meta = with stdenv.lib; {
    longDescription = ''
      Libao is Xiph.org's cross-platform audio library that allows
      programs to output audio using a simple API on a wide variety of
      platforms.
    '';
    homepage = https://xiph.org/ao/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = with platforms; unix;
  };
}
