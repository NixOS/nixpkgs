{stdenv, fetchurl, bash, yasm, which}:

stdenv.mkDerivation rec {
  name = "libvpx-0.9.6";
  
  src = fetchurl {
    url = http://webm.googlecode.com/files/libvpx-v0.9.6.tar.bz2;
    sha256 = "0wxay9wss4lawrcmnwqkpy0rdnaih1k7ilzh284mgyqnya78mg98";
  };

  patchPhase = ''
    sed -e 's,/bin/bash,${bash}/bin/bash,' -i configure build/make/version.sh \
      examples/gen_example_code.sh
    sed -e '/enable linux/d' -i configure
  '';

  configureScript = "../configure";

  preConfigure = ''
    mkdir -p build
    cd build
  '';

  configureFlags = [
    "--disable-install-srcs"
    "--disable-examples"
    "--enable-vp8"
    "--enable-runtime-cpu-detect"
    "--enable-shared"
    "--enable-pic"
  ];

  installPhase = ''
    make quiet=false DIST_DIR=$out install
  '';

  buildInputs = [ yasm which ];

  meta = {
    description = "VP8 video encoder";
    homepage = http://code.google.com/p/webm;
    license = "BSD";
  };
}

