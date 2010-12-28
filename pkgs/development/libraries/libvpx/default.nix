{stdenv, fetchurl, bash, yasm}:

stdenv.mkDerivation rec {
  name = "libvpx-0.9.1";
  
  src = fetchurl {
    url = http://webm.googlecode.com/files/libvpx-0.9.1.tar.bz2;
    sha256 = "0ngc8y12np2q6yhrrn6cbmlbzwbk10fnldj8d5dxxzvrw1iy9s64";
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

  buildInputs = [ yasm ];

  meta = {
    description = "VP8 video encoder";
    homepage = http://code.google.com/p/webm;
    license = "BSD";
  };
}

