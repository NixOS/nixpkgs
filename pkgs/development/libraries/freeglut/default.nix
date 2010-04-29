{stdenv, fetchurl, x11, mesa}:

stdenv.mkDerivation {
  name = "freeglut-2.4.0";

  src = fetchurl {
    url = mirror://sourceforge/freeglut/freeglut-2.4.0.tar.gz;
    sha256 = "0lmhh5p19rw4wisr0jsl7nsa2hxdaasj0vxk5ri83crhp982v7r6";
  };

  configureFlags = "--" + (if stdenv.isDarwin then "disable" else "enable") + "-warnings";

  buildInputs = [x11 mesa];
  patches = ./freeglut-gcc-4.2.patch;
}
