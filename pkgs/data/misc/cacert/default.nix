{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cacert-20110902";

  src = fetchurl {
    url = "http://nixos.org/tarballs/${name}.pem.bz2";
    sha256 = "05vwziwrckgdg4l029jsb8apj65lcvk0rfcyyrvz34m2znk0vlmi";
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
