{ stdenv, fetchFromGitHub, zlib, ffmpeg, pkgconfig }:

stdenv.mkDerivation rec {
  name = "ffms-${version}";
  version = "2.22";

  src = fetchFromGitHub {
    owner = "FFMS";
    repo = "ffms2";
    rev = version;
    sha256 = "1ywcx1f3q533qfrbck5qhik3l617qhm062l8zixv02gnla7w6rkm";
  };

  NIX_CFLAGS_COMPILE = "-fPIC";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib ffmpeg ];

  meta = with stdenv.lib; {
    homepage = http://github.com/FFMS/ffms2/;
    description = "Libav/ffmpeg based source library for easy frame accurate access";
    license = licenses.mit;
    maintainers = with maintainers; [ fuuzetsu ];
    platforms = platforms.unix;
  };
}
