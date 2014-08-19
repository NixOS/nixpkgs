{stdenv, fetchurl, bash, yasm, which, perl, binutils}:

let version = "1.3.0";
in
stdenv.mkDerivation rec {
  name = "libvpx-" + version;

  src = fetchurl { # sadly, there's no official tarball for this release
    url = "http://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2";
    sha1 = "191b95817aede8c136cc3f3745fb1b8c50e6d5dc";
  };

  patchPhase = ''
    sed -e 's,/bin/bash,${bash}/bin/bash,' -i configure build/make/version.sh \
      examples/gen_example_code.sh build/make/gen_asm_deps.sh
    sed -e '/enable linux/d' -i configure
  '';

  buildInputs = [ yasm which perl ]
    ++ stdenv.lib.optional stdenv.isDarwin binutils; # new asm opcode support

  preConfigure = ''
    mkdir -p build
    cd build
    substituteInPlace make/configure.sh --replace "-arch x86_64" "-march=x86-64"
  '';

  configureScript = "../configure";
  configureFlags =
    [ "--disable-install-srcs" "--disable-install-docs" "--disable-examples"
      "--enable-vp8" "--enable-runtime-cpu-detect" "--enable-pic" ]
    # --enable-shared is only supported on ELF
    ++ stdenv.lib.optional (!stdenv.isDarwin) "--disable-static --enable-shared";

  installPhase = ''
    make quiet=false DIST_DIR=$out install
  '';

  meta = with stdenv.lib; {
    description = "VP8 video encoder";
    homepage    = http://code.google.com/p/webm;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}

