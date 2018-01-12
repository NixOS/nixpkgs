{ stdenv, fetchFromGitHub, fetchurl, makeWrapper
, SDL, ffmpeg, frei0r, libjack2, libdv, libsamplerate
, libvorbis, libxml2, movit, pkgconfig, sox
, gtk2
}:

stdenv.mkDerivation rec {
  name = "mlt-${version}";
  version = "6.4.1";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
    sha256 = "0k9vj21n6qxdjd0vvj22cwi35igajjzh5fbjza766izdbijv2i2w";
  };

  patches = [
    # fix for glibc-2.26
    (fetchurl {
      url = "https://github.com/mltframework/mlt/commit/2125e3955a0d0be61571cf43b674f74b4b93c6f8.patch";
      sha256 = "1bgs5a3dblsmdmb7hwval9nmq1as4r4f48b3amsc23v69nsl2g0a";
    })
    # fix for glibc-2.26
    (fetchurl {
      url = "https://github.com/mltframework/mlt/commit/fbf6a5187776f2f392cf258935ff49e4c0e87024.patch";
      sha256 = "045vchpcznzsz47j67kxwdbg133kar66ssna3parnzrxdfqi72pv";
    })
  ];

  buildInputs = [
    SDL ffmpeg frei0r libjack2 libdv libsamplerate libvorbis libxml2
    makeWrapper movit pkgconfig sox
    gtk2
  ];

  # Mostly taken from:
  # http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/installing-source/installing-mlt-rendering-engine
  configureFlags = [
    "--avformat-swscale" "--enable-gpl" "--enable-gpl" "--enable-gpl3"
    "--enable-opengl"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/melt --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1

    # Remove an unnecessary reference to movit.dev.
    s=${movit.dev}/include
    t=$(for ((i = 0; i < ''${#s}; i++)); do echo -n X; done)
    sed -i $out/lib/mlt/libmltopengl.so -e "s|$s|$t|g"
  '';

  meta = with stdenv.lib; {
    description = "Open source multimedia framework, designed for television broadcasting";
    homepage = https://www.mltframework.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.tohl ];
    platforms = platforms.linux;
  };
}
