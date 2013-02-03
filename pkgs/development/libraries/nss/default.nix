{ stdenv, fetchurl, fetchgit, nspr, perl, zlib, sqlite
, includeTools ? false
}:

let

  nssPEM = fetchgit {
    url = "git://git.fedorahosted.org/git/nss-pem.git";
    rev = "07a683505d4a0a1113c4085c1ce117425d0afd80";
    sha256 = "e4a9396d90e50e8b3cceff45f312eda9aaf356423f4eddd354a0e1afbbfd4cf8";
  };

  secLoadPatch = fetchurl {
    name = "security_load.patch";
    urls = [
      # "http://patch-tracker.debian.org/patch/series/dl/nss/2:3.13.6-1/85_security_load.patch"
      # "http://anonscm.debian.org/gitweb/?p=pkg-mozilla/nss.git;a=blob_plain;f=debian/patches/85_security_load.patch;hb=HEAD"
      "http://www.parsix.org/export/7797/pkg/security/raul/main/nss/trunk/debian/patches/85_security_load.patch"
    ];
    sha256 = "8a8d0ae4ebbd7c389973fa5d26d8bc5f473046c6cb1d8283cb9a3c1f4c565c47";
  };

in stdenv.mkDerivation rec {
  name = "nss-${version}";
  version = "3.14";

  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_14_RTM/src/${name}.tar.gz";
    sha1 = "ace3642fb2ca67854ea7075d053ca01a6d81e616";
  };

  buildInputs = [ nspr perl zlib sqlite ];

  postUnpack = ''
    cp -rdv "${nssPEM}/mozilla/security/nss/lib/ckfw/pem" \
            "$sourceRoot/mozilla/security/nss/lib/ckfw/"
    chmod -R u+w "$sourceRoot/mozilla/security/nss/lib/ckfw/pem"
  '';

  patches = [
    ./nss-3.12.5-gentoo-fixups.diff
    secLoadPatch
    ./nix_secload_fixup.patch
  ];

  postPatch = ''
    sed -i -e 's/^DIRS.*$/& pem/' mozilla/security/nss/lib/ckfw/manifest.mn
    sed -i -e "/^PREFIX =/s:= /usr:= $out:" mozilla/security/nss/config/Makefile
  '';

  preConfigure = "cd mozilla/security/nss";

  makeFlags = [
    "NSPR_INCLUDE_DIR=${nspr}/include/nspr"
    "NSPR_LIB_DIR=${nspr}/lib"
    "NSDISTMODE=copy"
    "BUILD_OPT=1"
    "SOURCE_PREFIX=\$(out)"
    "NSS_ENABLE_ECC=1"
    "NSS_USE_SYSTEM_SQLITE=1"
  ] ++ stdenv.lib.optional stdenv.is64bit "USE_64=1";

  buildFlags = [ "build_coreconf" "build_dbm" "all" ];

  postInstall = ''
    rm -rf $out/private
    mv $out/public $out/include
    mv $out/*.OBJ/* $out/
    rmdir $out/*.OBJ

    cp -av config/nss-config $out/bin/nss-config
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
}
