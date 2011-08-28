{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cacert-20110806";

  src = fetchurl {
    url = "http://nixos.org/tarballs/${name}.pem.bz2";
    sha256 = "0vn1hic2a7p1vr2pf9hy8da4zm9qjndid4nwgj1m035y4ldjqlyw";
  };

  unpackPhase = "true";

  installPhase =
    ''
      ensureDir $out/etc
      bunzip2 < $src > $out/etc/ca-bundle.crt
    '';

  meta = {
    homepage = http://curl.haxx.se/docs/caextract.html;
    description = "A bundle of X.509 certificates of public Certificate Authorities (CA)";
  };
}
