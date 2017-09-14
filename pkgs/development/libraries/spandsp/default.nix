{stdenv, fetchurl, audiofile, libtiff}:
stdenv.mkDerivation rec {
  version = "0.0.6";
  name = "spandsp-${version}";
  src=fetchurl {
    url = "http://www.soft-switch.org/downloads/spandsp/spandsp-${version}.tar.gz";
    sha256 = "0rclrkyspzk575v8fslzjpgp4y2s4x7xk3r55ycvpi4agv33l1fc";
  };
  buildInputs = [];
  propagatedBuildInputs = [audiofile libtiff];
  meta = {
    homepage = http://www.creytiv.com/baresip.html;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = stdenv.lib.licenses.gpl2;
    downloadPage = "http://www.soft-switch.org/downloads/spandsp/";
    inherit version;
    updateWalker = true;
  };
}

