args:
args.stdenv.mkDerivation {
  name = "babl-0.0.20";

  src = args.fetchurl {
    url = ftp://ftp.gtk.org/pub/babl/0.0/babl-0.0.20.tar.bz2;
    sha256 = "15ilcwszhbfhiyzmjinlxbbpdhmvh9h6nacvqp59z8ai0dbjr54d";
  };

  buildInputs =(with args; []);

  meta = { 
      description = "image pixel format coneversion libraray";
      homepage = http://gegl.org/babl/;
      license = "GPL3";
  };
}
