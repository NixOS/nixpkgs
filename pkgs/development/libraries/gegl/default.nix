args:
args.stdenv.mkDerivation {
  name = "gegl-0.0.20";

  src = args.fetchurl {
    url = ftp://ftp.gimp.org/pub/gegl/0.0/gegl-0.0.20.tar.bz2;
    sha256 = "1dqdammp2jv6cwycwx5pwn5m9n3xss5j6656xb59dj4xxypvd2vh";
  };

  configureFlags = "--disable-docs"; # needs fonts otherwise  don't know how to pass them

  buildInputs =(with args; [pkgconfig glib babl libpng cairo libjpeg librsvg pango gtk]  );

  meta = { 
      description = "graph based image processing framework";
      homepage = http://www.gegl.org;
      license = "GPL3";
  };
}
