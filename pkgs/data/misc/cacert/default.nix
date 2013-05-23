{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cacert-20121229";

  src = fetchurl {
    url = "http://nixos.org/tarballs/${name}.pem.bz2";
    sha256 = "031s86pqvn620zkj6w97hqgjvkp6vsvlymzz7rwvkv25zvrjsgif";
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
