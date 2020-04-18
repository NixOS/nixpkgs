{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "meta-build-env-0.1";
  src = fetchurl {
    url = "http://www.meta-environment.org/releases/meta-build-env-0.1.tar.gz";
    sha256 = "1imn1gaan4fv73v8w3k3lgyjzkcn7bdp69k6hlz0vqdg17ysd1x3";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
