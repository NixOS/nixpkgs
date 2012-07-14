{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cacert-20120628";

  src = fetchurl {
    url = "http://nixos.org/tarballs/${name}.pem.bz2";
    sha256 = "0xg9f1w2pmsv221lgc60c07bs0xf2rr189a2yp2y9an95h3gx7ir";
  };

  unpackPhase = "true";

  installPhase =
    ''
      mkdir -p $out/etc
      bunzip2 < $src > $out/etc/ca-bundle.crt
    '';

  meta = {
    homepage = http://curl.haxx.se/docs/caextract.html;
    description = "A bundle of X.509 certificates of public Certificate Authorities (CA)";
  };
}
