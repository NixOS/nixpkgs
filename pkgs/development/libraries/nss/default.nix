{ stdenv, fetchurl, nspr, perl, zlib, sqlite }:

let

  nssPEM = fetchurl {
    url = http://dev.gentoo.org/~polynomial-c/mozilla/nss-3.15.4-pem-support-20140109.patch.xz;
    sha256 = "10ibz6y0hknac15zr6dw4gv9nb5r5z9ym6gq18j3xqx7v7n3vpdw";
  };

in stdenv.mkDerivation rec {
  name = "nss-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://mozilla/security/nss/releases/NSS_3_28_1_RTM/src/${name}.tar.gz";
    sha256 = "58cc0c05c0ed9523e6d820bea74f513538f48c87aac931876e3d3775de1a82ad";
  };

  buildInputs = [ nspr perl zlib sqlite ];

  prePatch = ''
    xz -d < ${nssPEM} | patch -p1
  '';

  patches =
    [ # FIXME: what is this patch for? Do we still need it?
      (fetchurl {
        url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/nss/files/nss-3.28-gentoo-fixups.patch";
        sha256 = "0z58axd1n7vq4kdp5mrb3dsg6di39a1g40s3shl6n2dzs14c1y2q";
      })
      # Based on http://patch-tracker.debian.org/patch/series/dl/nss/2:3.15.4-1/85_security_load.patch
      ./85_security_load.patch
    ];

  patchFlags = "-p0";

  postPatch = ''
    # Fix up the patch from Gentoo.
    sed -i \
      -e "/^PREFIX =/s|= /usr|= $out|" \
      -e '/@libdir@/s|gentoo/nss|lib|' \
      -e '/ln -sf/d' \
      nss/config/Makefile

    # Note for spacing/tab nazis: The TAB characters are intentional!
    cat >> nss/config/Makefile <<INSTALL_TARGET
    install:
    	mkdir -p \$(DIST)/lib/pkgconfig
    	cp nss.pc \$(DIST)/lib/pkgconfig
    INSTALL_TARGET
  '';

  outputs = [ "out" "dev" "tools" ];

  preConfigure = "cd nss";

  makeFlags = [
    "NSPR_INCLUDE_DIR=${nspr.dev}/include/nspr"
    "NSPR_LIB_DIR=${nspr.out}/lib"
    "NSDISTMODE=copy"
    "BUILD_OPT=1"
    "SOURCE_PREFIX=\$(out)"
    "NSS_ENABLE_ECC=1"
    "USE_SYSTEM_ZLIB=1"
    "NSS_USE_SYSTEM_SQLITE=1"
  ] ++ stdenv.lib.optional stdenv.is64bit "USE_64=1";

  NIX_CFLAGS_COMPILE = "-Wno-error";

  postInstall = ''
    rm -rf $out/private
    mv $out/public $out/include
    mv $out/*.OBJ/* $out/
    rmdir $out/*.OBJ

    cp -av config/nss-config $out/bin/nss-config

    ln -s lib $out/lib64
  '';

  postFixup = ''
    for libname in freebl3 nssdbm3 softokn3
    do
      libfile="$out/lib/lib$libname.so"
      LD_LIBRARY_PATH=$out/lib $out/bin/shlibsign -v -i "$libfile"
    done

    moveToOutput bin "$tools"
    moveToOutput bin/nss-config "$dev"
    moveToOutput lib/libcrmf.a "$dev" # needed by firefox, for example
    rm "$out"/lib/*.a
  '';

  meta = {
    homepage = https://developer.mozilla.org/en-US/docs/NSS;
    description = "A set of libraries for development of security-enabled client and server applications";
    platforms = stdenv.lib.platforms.all;
  };
}
