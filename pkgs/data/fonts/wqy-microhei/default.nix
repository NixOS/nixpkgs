{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wqy-microhei-0.2.0-beta";

  src = fetchurl {
    url = "mirror://sourceforge/wqy/${name}.tar.gz";
    sha256 = "0gi1yxqph8xx869ichpzzxvx6y50wda5hi77lrpacdma4f0aq0i8";
  };

  installPhase = ''install -Dm644 wqy-microhei.ttc $out/share/fonts/wqy-microhei.ttc'';

  meta = {
    description = "A (mainly) Chinese Unicode font";
    homepage = "http://wenq.org";
    license = stdenv.lib.licenses.asl20;
    maintainers = stdenv.lib.maintainers.pkmx;
    platforms = stdenv.lib.platforms.all;
  };
}

