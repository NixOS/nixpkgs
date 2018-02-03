{ stdenv, fetchurl, nspr, perl, zlib, sqlite }:

let

  nssPEM = fetchurl {
    url = http://dev.gentoo.org/~polynomial-c/mozilla/nss-3.15.4-pem-support-20140109.patch.xz;
    sha256 = "10ibz6y0hknac15zr6dw4gv9nb5r5z9ym6gq18j3xqx7v7n3vpdw";
  };

in stdenv.mkDerivation rec {
  name = "nss-${version}";
  version = "3.34.1";

  src = fetchurl {
    url = "mirror://mozilla/security/nss/releases/NSS_3_34_1_RTM/src/${name}.tar.gz";
    sha256 = "186x33wsk4mzjz7dzbn8p0py9a0nzkgzpfkdv4rlyy5gghv5vhd3";
  };

  buildInputs = [ perl zlib sqlite ];

  propagatedBuildInputs = [ nspr ];

  prePatch = ''
    xz -d < ${nssPEM} | patch -p1
  '';

  patches =
    [
      # Based on http://patch-tracker.debian.org/patch/series/dl/nss/2:3.15.4-1/85_security_load.patch
      ./85_security_load.patch
      ./ckpem.patch
    ];

  patchFlags = "-p0";

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
  ] ++ stdenv.lib.optional stdenv.is64bit "USE_64=1"
    ++ stdenv.lib.optional stdenv.isDarwin "CCC=clang++";

  NIX_CFLAGS_COMPILE = "-Wno-error";

  postInstall = ''
    rm -rf $out/private
    mv $out/public $out/include
    mv $out/*.OBJ/* $out/
    rmdir $out/*.OBJ

    ln -s lib $out/lib64

    # Upstream issue: https://bugzilla.mozilla.org/show_bug.cgi?id=530672
    # https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/nss/files/nss-3.32-gentoo-fixups.patch?id=af1acce6c6d2c3adb17689261dfe2c2b6771ab8a
    NSS_MAJOR_VERSION=`grep "NSS_VMAJOR" lib/nss/nss.h | awk '{print $3}'`
    NSS_MINOR_VERSION=`grep "NSS_VMINOR" lib/nss/nss.h | awk '{print $3}'`
    NSS_PATCH_VERSION=`grep "NSS_VPATCH" lib/nss/nss.h | awk '{print $3}'`
    PREFIX="$out"

    mkdir -p $out/lib/pkgconfig
    sed -e "s,%prefix%,$PREFIX," \
        -e "s,%exec_prefix%,$PREFIX," \
        -e "s,%libdir%,$PREFIX/lib64," \
        -e "s,%includedir%,$dev/include/nss," \
        -e "s,%NSS_VERSION%,$NSS_MAJOR_VERSION.$NSS_MINOR_VERSION.$NSS_PATCH_VERSION,g" \
        -e "s,%NSPR_VERSION%,4.16,g" \
        pkg/pkg-config/nss.pc.in > $out/lib/pkgconfig/nss.pc
    chmod 0644 $out/lib/pkgconfig/nss.pc

    sed -e "s,@prefix@,$PREFIX," \
        -e "s,@MOD_MAJOR_VERSION@,$NSS_MAJOR_VERSION," \
        -e "s,@MOD_MINOR_VERSION@,$NSS_MINOR_VERSION," \
        -e "s,@MOD_PATCH_VERSION@,$NSS_PATCH_VERSION," \
        pkg/pkg-config/nss-config.in > $out/bin/nss-config
    chmod 0755 $out/bin/nss-config
  '';

  postFixup = ''
    for libname in freebl3 nssdbm3 softokn3
    do '' +
    (if stdenv.isDarwin
     then ''
       libfile="$out/lib/lib$libname.dylib"
       DYLD_LIBRARY_PATH=$out/lib:${nspr.out}/lib \
     '' else ''
       libfile="$out/lib/lib$libname.so"
       LD_LIBRARY_PATH=$out/lib:${nspr.out}/lib \
     '') + ''
        $out/bin/shlibsign -v -i "$libfile"
    done

    moveToOutput bin "$tools"
    moveToOutput bin/nss-config "$dev"
    moveToOutput lib/libcrmf.a "$dev" # needed by firefox, for example
    rm -f "$out"/lib/*.a
  '';

  meta = {
    homepage = https://developer.mozilla.org/en-US/docs/NSS;
    description = "A set of libraries for development of security-enabled client and server applications";
    platforms = stdenv.lib.platforms.all;
  };
}
