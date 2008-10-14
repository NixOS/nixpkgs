args:
args.stdenv.mkDerivation {
  name = "faad2-2.6.1";

  src = args.fetchurl {
    url = http://downloads.sourceforge.net/faac/faad2-2.6.1.tar.gz;
    sha256 = "0p1870qfpaadphdfphbcfalf6d25r30k3y1f7sa7ly4vq3hc5lla";
  };

  preConfigure = "./bootstrap";

  buildInputs =(with args; [autoconf automake libtool]);

  meta = {
      description="AAC audio decoding library";
      homepage = http://www.audiocoding.com/faad2.html;
      license = "GPLv2";
  };
}
