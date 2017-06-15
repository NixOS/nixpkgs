{ stdenv, fetchurl, nspr, perl, zlib, sqlite }:

let

  nssPEM = fetchurl {
    url = http://dev.gentoo.org/~polynomial-c/mozilla/nss-3.15.4-pem-support-20140109.patch.xz;
    sha256 = "10ibz6y0hknac15zr6dw4gv9nb5r5z9ym6gq18j3xqx7v7n3vpdw";
  };

in stdenv.mkDerivation rec {
  name = "nss-${version}";
  version = "3.31";
  url_version = builtins.replaceStrings [ "." ] [ "_" ] version;

  src = fetchurl {
    url = "mirror://mozilla/security/nss/releases/NSS_${url_version}_RTM/src/${name}.tar.gz";
    sha256 = "0pd643a8ns7q5az5ai3ascrw666i2kbfiyy1c9hlhw9jd8jn21g9";
  };

  buildInputs = [ perl zlib sqlite ];

  propagatedBuildInputs = [ nspr ];

  prePatch = ''
    xz -d < ${nssPEM} | patch -p1
  '';

  patches =
    [ # Install a nss.pc (pkgconfig) file and nss-config script
      # Upstream issue: https://bugzilla.mozilla.org/show_bug.cgi?id=530672
      (fetchurl {
        name = "nss-3.28-gentoo-fixups.patch";
        url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/"
            + "dev-libs/nss/files/nss-3.28-gentoo-fixups.patch"
            + "?id=05c31f8cca591b3ce8219e4def7c26c7b1b130d6";
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
