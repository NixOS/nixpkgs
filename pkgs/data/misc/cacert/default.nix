{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cacert-20090922";

  src = fetchurl {
    url = http://nixos.org/tarballs/cacert-20090922.pem.bz2;
    sha256 = "1fakipxy5y62vslw6czj24pksh16b042py9v0199mxhzg5nmbmy7";
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
