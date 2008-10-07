args: with args;

# this is the stable edition of OpenMotif - sources fetched from Debian, without
# patches applied

stdenv.mkDerivation {
  name = "openmotif-2.2.3";
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/non-free/o/openmotif/openmotif_2.2.3.orig.tar.gz; 
    sha256 = "0amd9834p1ajnin7c8f1gad2jl2csf69msxcpc10rzm2x27jigxi";
  };

  unpackPhase = ''
    tar xzf $src
    tar xzf openmotif-2.2.3.orig/dist/openMotif-2.2.3.tar.gz
    rm -rf openmotif-2.2.3.orig
    cd openMotif-2.2.3
  '';

  buildInputs = [flex perl];
  propagatedBuildInputs = [x11 libXp libXau libXaw libXext xbitmaps];

  CFLAGS="-fno-strict-aliasing";  # without this openmotif may segfault

  meta = {
    description = "Open source version of motif toolkit including aka libmotif3";
    homepage = http://www.opengroup.org/openmotif/;
    # Open motif is free for open source projects
    license = "non-free";
  };
}

