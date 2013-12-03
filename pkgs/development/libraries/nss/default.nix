{ stdenv, fetchurl, nspr, perl, zlib, sqlite
, includeTools ? false
}:

let

  nssPEM = fetchurl {
    url = http://dev.gentoo.org/~anarchy/patches/nss-3.15-pem-support-20130617.patch.xz;
    sha256 = "1k1m8lsgqwxx251943hks1dd13hz1adpqqb0hxwn011by5vmi201";
  };

  secLoadPatch = fetchurl {
    name = "security_load.patch";
    urls = http://patch-tracker.debian.org/patch/series/dl/nss/2:3.15.3-1/85_security_load.patch;
    sha256 = "041c6v4cxwsy14qr5m9qs0gkv3w24g632cwpz27kacxpa886r1ds";
  };

in stdenv.mkDerivation rec {
  name = "nss-${version}";
  version = "3.15.3";

  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_15_3_RTM/src/${name}.tar.gz";
    sha1 = "1d0f6707eda35f6c7be92fe2b0537dc090a8f203";
  };

  buildInputs = [ nspr perl zlib sqlite ];

  prePatch = ''
    xz -d < ${nssPEM} | patch -p1
  '';

  patches =
    [ ./nss-3.15-gentoo-fixups.patch
      secLoadPatch
      ./nix_secload_fixup.patch
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
