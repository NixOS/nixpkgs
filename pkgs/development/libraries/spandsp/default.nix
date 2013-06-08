{stdenv, fetchurl, audiofile, libtiff}:
stdenv.mkDerivation rec {
  version = "0.0.5";
  name = "spandsp-${version}";
  src=fetchurl {
    url = "http://www.soft-switch.org/downloads/spandsp/spandsp-${version}.tgz";
    sha256 = "07f42a237c77b08fa765c3a148c83cdfa267bf24c0ab681d80b90d30dd0b3dbf";
  };
  buildInputs = [];
  propagatedBuildInputs = [audiofile libtiff];
  meta = {
    homepage = "http://www.creytiv.com/baresip.html";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = with stdenv.lib.licenses; gpl2;
  };
}

