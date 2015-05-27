{ stdenv, fetchurl, audiofile, libtiff }:

stdenv.mkDerivation rec {
  name = "spandsp-0.0.6";

  src=fetchurl {
    url = "http://www.soft-switch.org/downloads/spandsp/${name}.tar.gz";
    sha256 = "0rclrkyspzk575v8fslzjpgp4y2s4x7xk3r55ycvpi4agv33l1fc";
  };

  buildInputs = [ audiofile ];

  propagatedBuildInputs = [ libtiff ];

  meta = with stdenv.lib; {
    description = "SpanDSP is a library of DSP functions for telephony";
    homepage = http://www.soft-switch.org/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ raskin ];
    license = licenses.gpl2;
  };
}
