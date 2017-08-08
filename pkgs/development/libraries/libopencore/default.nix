{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "opencore-amr";
  src = fetchurl {
    url = https://vorboss.dl.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.5.tar.gz;
    sha256 = "0hfk9khz3by0119h3jdwgdfd7jgkdbzxnmh1wssvylgnsnwnq01c";
  };

}
