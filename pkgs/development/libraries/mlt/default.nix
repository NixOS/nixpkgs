{ stdenv, fetchFromGitHub, makeWrapper, pkgconfig, which
, SDL, SDL2, ffmpeg, frei0r, libjack2, libdv, libsamplerate
, libvorbis, libxml2, movit, sox, qtbase, qtsvg, gtk2
, fftw, vid-stab, opencv3, ladspa-sdk, libexif
}:

let inherit (stdenv.lib) getDev; in

stdenv.mkDerivation rec {
  name = "mlt-${version}";
  version = "6.12.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
    sha256 = "0pzm3mjbbdl2rkbswgyfkx552xlxh2qrwzsi2a4dicfr92rfgq6w";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig which ];
  buildInputs = [
    SDL SDL2 ffmpeg frei0r libjack2 libdv libsamplerate libvorbis libxml2
    movit qtbase qtsvg sox fftw vid-stab opencv3
    ladspa-sdk libexif gtk2
  ];

  configureFlags = [
    "--enable-gpl"
    "--enable-gpl3"
    "--enable-opengl"
    # must be enabled explicitly
    "--enable-opencv" 
  ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/melt --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1
  '';

  passthru = {
    inherit ffmpeg;
  };

  meta = with stdenv.lib; {
    description = "Open source multimedia framework, designed for television broadcasting";
    homepage = https://www.mltframework.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ goibhniu tohl ];
    platforms = platforms.linux;
  };
}
