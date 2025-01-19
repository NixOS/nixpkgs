{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation {
  pname = "tegaki-zinnia-japanese";
  version = "0.3";

  src = fetchurl {
    url = "http://www.tegaki.org/releases/0.3/models/tegaki-zinnia-japanese-0.3.zip";
    sha256 = "1nmg9acxhcqly9gwkyb9m0hpy76fll91ywk4b1q4xms0ajxip1h7";
  };

  meta = {
    description = "Japanese handwriting model for the Zinnia engine";
    homepage = "http://tegaki.org/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.gebner ];
  };

  nativeBuildInputs = [ unzip ];

  makeFlags = [ "installpath=$(out)/share/tegaki/models/zinnia/" ];
}
