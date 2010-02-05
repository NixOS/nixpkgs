args: with args;

stdenv.mkDerivation {
  name = "glew-1.5.2";

  src = fetchurl {
    url = mirror://sourceforge/glew/glew-1.5.2.tgz;
    sha256 = "0dh5wpfq7aaldkiwcqmm9w59c2qcglkjv8zazmnm8n5771n3caj8";
  };

  buildInputs = [mesa x11 libXmu libXi];

  meta = { 
    description = "cross-platform open-source C/C++ extension loading library";
    homepage = http://glew.sourceforge.net/;
    license = ["BSD" "GLX" "SGI-B" "GPL2"]; # License description copied from gentoo-1.4.0 
  };

  installPhase="GLEW_DEST=\$out make install";
}
