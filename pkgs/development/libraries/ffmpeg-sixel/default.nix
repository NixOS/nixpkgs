{ stdenv, fetchFromGitHub, pkgconfig, perl, libsixel, yasm
}:

stdenv.mkDerivation rec {

  name = "ffmpeg-sixel-${version}";
  version = "nightly-2.3.x";

  src = fetchFromGitHub {
    owner = "saitoha";
    repo = "FFmpeg-SIXEL";
    rev = "8566fdb8b7516b54aed58f329dc216e06fc10052";
    sha256 = "00s2lggfdj2ibpngpyqqg7360p7yb69ys1ppg59yvv0m0mxk5x3k";
  };

  buildInputs = [
    pkgconfig
    libsixel
    yasm
  ];

  configurePhase = ''
    ./configure --enable-libsixel --prefix=$out
  '';

  postInstall = ''
    mv $out/bin/ffmpeg $out/bin/ffmpeg-sixel
  '';

  meta = with stdenv.lib; {
    description = "A complete, cross-platform solution to record, convert and stream audio and video, extended to support console graphics";
    homepage = http://www.ffmpeg.org/;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ vrthra ];
  };
}
