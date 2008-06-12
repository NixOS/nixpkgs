{stdenv, fetchurl, libxml2}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "libxslt-1.1.24";
  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxslt-1.1.24.tar.gz;
    sha256 = "0ghb31mgm3bq5k41jf7b0c2azcfil26nz720kpr7k6hyhi20khf0";
  };
  buildInputs = [libxml2];
  postInstall = "ensureDir $out/nix-support; ln -s ${libxml2}/nix-support/setup-hook $out/nix-support/";
}
