args:
args.stdenv.mkDerivation {
  name = "glew-1.5.0";

  src = args.fetchurl {
    url = http://dfn.dl.sourceforge.net/sourceforge/glew/glew-1.5.0-src.tgz;
    sha256 = "1kjr1fchnl785wsg11vzc03q3pm12lh20n1i593zr1xqfjgx2b4h";
  };

  buildInputs =(with args; [mesa x11 libXmu libXi libtool]);

  meta = { 
      description = "cross-platform open-source C/C++ extension loading library";
      homepage = http://glew.sourceforge.net/;
      license = ["BSD" "GLX" "SGI-B" "GPL2"]; # License description copied from gentoo-1.4.0 
  };
}
