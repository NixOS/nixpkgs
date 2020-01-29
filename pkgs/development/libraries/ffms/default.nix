{ stdenv, fetchFromGitHub, zlib, ffmpeg, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "ffms";
  version = "2.23";

  src = fetchFromGitHub {
    owner = "FFMS";
    repo = "ffms2";
    rev = version;
    sha256 = "0dkz5b3gxq5p4xz0qqg6l2sigszrlsinz3skyf0ln4wf3zrvf8m5";
  };

  NIX_CFLAGS_COMPILE = "-fPIC";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib ffmpeg ];

  # ffms includes a built-in vapoursynth plugin, see:
  # https://github.com/FFMS/ffms2#avisynth-and-vapoursynth-plugin
  postInstall = ''
    mkdir $out/lib/vapoursynth
    ln -s $out/lib/libffms2.so $out/lib/vapoursynth/libffms2.so
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/FFMS/ffms2/;
    description = "Libav/ffmpeg based source library for easy frame accurate access";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
