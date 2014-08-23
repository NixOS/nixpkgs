{ stdenv, fetchurl, nspr, perl, zlib, sqlite
, includeTools ? false
}:

let

  nssPEM = fetchurl {
    url = http://dev.gentoo.org/~polynomial-c/mozilla/nss-3.15.4-pem-support-20140109.patch.xz;
    sha256 = "10ibz6y0hknac15zr6dw4gv9nb5r5z9ym6gq18j3xqx7v7n3vpdw";
  };

in stdenv.mkDerivation rec {
  name = "nss-${version}";
  version = "3.16.3";

  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_16_3_RTM/src/${name}.tar.gz";
    sha256 = "657711ff7a4058043b69019a66f44101d0234eae2b6b80ab900439dbf02add60";
  };

  buildInputs = [ nspr perl zlib sqlite ];

  prePatch = ''
    xz -d < ${nssPEM} | patch -p1
  '';

  patches =
    [ ./nss-3.15-gentoo-fixups.patch
      # Based on http://patch-tracker.debian.org/patch/series/dl/nss/2:3.15.4-1/85_security_load.patch
      ./85_security_load.patch
    ];

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

  preConfigure = "cd nss";

  makeFlags = [
    "NSPR_INCLUDE_DIR=${nspr}/include/nspr"
    "NSPR_LIB_DIR=${nspr}/lib"
    "NSDISTMODE=copy"
    "BUILD_OPT=1"
    "SOURCE_PREFIX=\$(out)"
    "NSS_ENABLE_ECC=1"
    "NSS_USE_SYSTEM_SQLITE=1"
  ] ++ stdenv.lib.optional stdenv.is64bit "USE_64=1";

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
  '' + stdenv.lib.optionalString (!includeTools) ''
    find $out/bin -type f \( -name nss-config -o -delete \)
  '';

  meta = {
    homepage = https://developer.mozilla.org/en-US/docs/NSS;
    description = "A set of libraries for development of security-enabled client and server applications";
  };
}
