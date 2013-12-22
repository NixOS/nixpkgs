{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cacert-20131205";

  src = fetchurl {
    url = "http://tarballs.nixos.org/${name}.pem.bz2";
    sha256 = "049cm3nrhawkh9xpfjhgis6w58zji5ppi4d9yyjzrr7mpw0a34df";
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
