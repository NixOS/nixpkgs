{ lib, stdenv, fetchurl, fetchpatch, autoreconfHook, pkg-config, fftw, speexdsp }:

stdenv.mkDerivation rec {
  pname = "speex";
  version = "1.2.0";

  src = fetchurl {
    url = "http://downloads.us.xiph.org/releases/speex/speex-${version}.tar.gz";
    sha256 = "150047wnllz4r94whb9r73l5qf0z5z3rlhy98bawfbblmkq8mbpa";
  };

  postPatch = ''
    sed -i '/AC_CONFIG_MACRO_DIR/i PKG_PROG_PKG_CONFIG' configure.ac
  '';

  patches = [
    (fetchpatch {
      name = "CVE-2020-23903.patch";
      url = "https://github.com/xiph/speex/commit/870ff845b32f314aec0036641ffe18aba4916887.patch";
      sha256 = "sha256-uEMDhDTw/LIWNPPCXW6kF+udBmNO88G/jJTojAA9fs8=";
    })
  ];

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fftw speexdsp ];

  # TODO: Remove this will help with immediate backward compatability
  propagatedBuildInputs = [ speexdsp ];

  configureFlags = [
    "--with-fft=gpl-fftw3"
  ];

  meta = with lib; {
    homepage = "https://www.speex.org/";
    description = "An Open Source/Free Software patent-free audio compression format designed for speech";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
