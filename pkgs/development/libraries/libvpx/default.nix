{stdenv, fetchurl, bash}:

stdenv.mkDerivation rec {
  name = "libvpx-0.9.0";
  
  src = fetchurl {
    url = http://webm.googlecode.com/files/libvpx-0.9.0.tar.bz2;
    sha256 = "1p5rl7r8zpw43n8i38wv73na8crkkakw16yx0v7n3ywwhp36l2d0";
  };

  patchPhase = ''
    sed -e 's,/bin/bash,${bash}/bin/bash,' -i configure build/make/version.sh \
      examples/gen_example_code.sh
  '';

  configurePhase = ''
    mkdir -p build
    cd build
    ../configure --disable-install-srcs --disable-examples --enable-vp8 --enable-runtime-cpu-detect
  '';

  installPhase = ''
    make quiet=false DIST_DIR=$out install
  '';

  meta = {
    description = "VP8 video encoder";
    homepage = http://code.google.com/p/webm;
    license = "BSD";
  };
}

