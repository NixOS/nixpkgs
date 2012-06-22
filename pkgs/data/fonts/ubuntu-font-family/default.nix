{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "ubuntu-font-family-0.80";
  buildInputs = [unzip];

  src = fetchurl {
    url = http://font.ubuntu.com/download/ubuntu-font-family-0.80.zip;
    sha256 = "107170099bbc3beae8602b97a5c423525d363106c3c24f787d43e09811298e4c";
  };

  installPhase =
    ''
      mkdir -p $out/share/fonts/ubuntu
      cp *.ttf $out/share/fonts/ubuntu
    '';

  meta = {
    description = "The Ubuntu typeface has been specially created to complement the Ubuntu tone of voice. It has a contemporary style and contains characteristics unique to the Ubuntu brand that convey a precise, reliable and free attitude.";
  };
}
