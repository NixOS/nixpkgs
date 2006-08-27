{stdenv, fetchurl, gettext}:

assert gettext != null;

stdenv.mkDerivation {
  name = "popt-1.10.6";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/popt-1.10.6.tar.gz;
    md5 = "76b4bbcda13eb7fa86b9af893c648202";
  };
  buildInputs = [gettext];
}
