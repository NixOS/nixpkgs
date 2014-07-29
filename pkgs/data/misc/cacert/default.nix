{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cacert-20140704";

  src = fetchurl {
    url = "http://tarballs.nixos.org/${name}.pem.bz2";
    sha256 = "05ymb7lrxavscbpx5xywlbya9q66r26fbngfif6zrvfpf3qskiza";
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
