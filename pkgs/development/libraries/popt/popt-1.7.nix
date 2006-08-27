{stdenv, fetchurl, gettext}:

assert gettext != null;

stdenv.mkDerivation {
  name = "popt-1.7";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/popt-1.7.tar.gz;
    md5 = "5988e7aeb0ae4dac8d83561265984cc9";
  };
  buildInputs = [gettext];
}
