{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "iana-etc-2.20";

  src = fetchurl {
    url = http://www.sethwklein.net/projects/iana-etc/downloads/iana-etc-2.20.tar.bz2;
    md5 = "51d584b7b6115528c21e8ea32250f2b1";
  };

  preInstall = "installFlags=\"PREFIX=$out\"";
}
