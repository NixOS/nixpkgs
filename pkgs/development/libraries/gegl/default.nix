args:
args.stdenv.mkDerivation {
  name = "gegl-0.0.16";

  src = args.fetchurl {
    url = ftp://ftp.gimp.org/pub/gegl/0.0/gegl-0.0.16.tar.bz2;
    sha256 = "0jgbqgpv85x9kc14zi6a6bs6jvsm3hy48nvwrhhygmivayswa3qj";
  };

  configureFlags = "--disable-docs"; # needs fonts otherwise  don't know how to pass them

  buildInputs =(with args; [pkgconfig glib babl libpng cairo libjpeg librsvg pango ]  );

  meta = { 
      description = "graph based image processing framework";
      homepage = http://www.gegl.org;
      license = "GPL3";
  };
}
