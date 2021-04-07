{lib, stdenv, fetchurl, audiofile, libtiff}:
stdenv.mkDerivation rec {
  version = "0.0.6";
  pname = "spandsp";
  src=fetchurl {
    url = "https://www.soft-switch.org/downloads/spandsp/spandsp-${version}.tar.gz";
    sha256 = "0rclrkyspzk575v8fslzjpgp4y2s4x7xk3r55ycvpi4agv33l1fc";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [audiofile libtiff];
  meta = {
    description = "A portable and modular SIP User-Agent with audio and video support";
    homepage = "http://www.creytiv.com/baresip.html";
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [raskin];
    license = lib.licenses.gpl2;
    downloadPage = "http://www.soft-switch.org/downloads/spandsp/";
    inherit version;
    updateWalker = true;
  };
}
