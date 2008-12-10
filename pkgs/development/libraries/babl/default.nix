args:
args.stdenv.mkDerivation {
  name = "babl-0.0.22";

  src = args.fetchurl {
    url = ftp://ftp.gtk.org/pub/babl/0.0/babl-0.0.22.tar.bz2;
    sha256 = "0v8gbf9si4sd06199f8lfmrsbvi6i0hxphd34kyvsj6g2kkkg10s";
  };

  buildInputs =(with args; []);

  meta = { 
      description = "image pixel format coneversion libraray";
      homepage = http://gegl.org/babl/;
      license = "GPL3";
  };
}
