{ stdenv, lib, fetchurl, libXi, libXrandr, libXxf86vm, mesa, x11, autoreconfHook }:

let version = "2.8.1";
in stdenv.mkDerivation {
  name = "freeglut-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/freeglut/freeglut-${version}.tar.gz";
    sha256 = "16lrxxxd9ps9l69y3zsw6iy0drwjsp6m26d1937xj71alqk6dr6x";
  };

  buildInputs = [
    libXi libXrandr libXxf86vm mesa x11
  ] ++ lib.optionals stdenv.isDarwin [
    autoreconfHook
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.am --replace \
      "SUBDIRS = src include progs doc" \
      "SUBDIRS = src include doc"
  '';

  configureFlags = [ "--enable-warnings" ];

  meta = with stdenv.lib; {
    description = "Create and manage windows containing OpenGL contexts";
    longDescription = ''
      FreeGLUT is an open source alternative to the OpenGL Utility Toolkit
      (GLUT) library. GLUT (and hence FreeGLUT) allows the user to create and
      manage windows containing OpenGL contexts on a wide range of platforms
      and also read the mouse, keyboard and joystick functions. FreeGLUT is
      intended to be a full replacement for GLUT, and has only a few
      differences.
    '';
    homepage = http://freeglut.sourceforge.net/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
