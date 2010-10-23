{stdenv, fetchurl, ncompress}:

stdenv.mkDerivation rec {
  name = "urt-${version}";
  version = "3.1b";
  
  src = fetchurl {
    url = ftp://ftp.iastate.edu/pub/utah-raster/urt-3.1b.tar.Z;
    sha256 = "0hbb3avgvkfb2cksqn6cmmgcr0278nb2qd1srayqx0876pq6g2vd";
  };

  buildInputs = [ ncompress ];

  unpackPhase = ''
      mkdir urt
      tar xvf "$src" -C urt
  '';
  patchFlags = "-p0 -d urt";
  patches = [ ./urt-3.1b-build-fixes.patch ./urt-3.1b-compile-updates.patch
              ./urt-3.1b-make.patch ./urt-3.1b-rle-fixes.patch ./urt-3.1b-tempfile.patch ];
  postPatch = ''
      cd urt

      rm bin/README
      rm man/man1/template.1

      # stupid OS X declares a stack_t type already 
      sed -i -e 's:stack_t:_urt_stack:g' tools/clock/rleClock.c

      sed -i -e '/^CFLAGS/s: -O : :' makefile.hdr

      cp "${./gentoo-config}" config/gentoo
  '';
  configurePhase = ''
      ./Configure config/gentoo
  '';
  postInstall = ''
      mkdir -p $out/bin
      cp bin/* $out/bin

      mkdir -p $out/lib
      cp lib/librle.a $out/lib

      mkdir -p $out/include
      cp include/rle*.h $out/include

      mkdir -p $out/share/man/man1
      cp man/man1/*.1 $out/share/man/man1

      mkdir -p $out/share/man/man3
      cp man/man3/*.3 $out/share/man/man3

      mkdir -p $out/share/man/man5
      cp man/man5/*.5 $out/share/man/man5
  '';

  meta = {
    homepage = http://www.cs.utah.edu/gdc/projects/urt/;
    description = "The Utah Raster Toolkit is a library for dealing with raster images";
  };
}