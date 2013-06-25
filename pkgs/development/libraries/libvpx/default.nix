{stdenv, fetchurl, bash, yasm, which, perl}:

let version = "1.2.0";
in
stdenv.mkDerivation rec {
  name = "libvpx-" + version;

  src = fetchurl { # sadly, there's no official tarball for this release
    url = "ftp://ftp.archlinux.org/other/libvpx/libvpx-${version}.tar.xz";
    sha256 = "02k9ylswgr2hvjqmg422fa9ggym0g94gzwb14nnckly698rvjc50";
  };

  patchPhase = ''
    sed -e 's,/bin/bash,${bash}/bin/bash,' -i configure build/make/version.sh \
      examples/gen_example_code.sh build/make/gen_asm_deps.sh
    sed -e '/enable linux/d' -i configure
  '';

  buildInputs = [ yasm which perl ];

  preConfigure = ''
    mkdir -p build
    cd build
  '';

  configureScript = "../configure";
  configureFlags = [
    "--disable-install-srcs"
    "--disable-install-docs"
    "--disable-examples"
    "--enable-vp8"
    "--enable-runtime-cpu-detect"
    "--enable-shared"
    "--enable-pic"
  ];

  installPhase = ''
    make quiet=false DIST_DIR=$out install
  '';

  meta = {
    description = "VP8 video encoder";
    homepage = http://code.google.com/p/webm;
    license = "BSD";
  };
}

