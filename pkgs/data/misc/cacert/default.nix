{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cacert-20140715";

  src = fetchurl {
    url = "http://tarballs.nixos.org/${name}.pem.bz2";
    sha256 = "1l4j7z6ysnllx99isjzlc8zc34rbbgj4kzlg1y5sy9bgphc8cssl";
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
