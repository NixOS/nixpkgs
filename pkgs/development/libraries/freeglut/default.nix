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

  # patches = [ ./0001-remove-typedefs-now-living-in-mesa.patch ];
}
