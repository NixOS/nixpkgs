{ stdenv, fetchurl, fetchgit, nspr, perl, zlib, sqlite
, includeTools ? false
}:

let

  nssConfig = fetchurl {
    url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/dev-libs/nss/files/3.12-nss-config.in?rev=1.2";
    sha256 = "1ck9q68fxkjq16nflixbqi4xc6bmylmj994h3f1j42g8mp0xf0vd";
  };

  nssPEM = fetchgit {
    url = "git://git.fedorahosted.org/git/nss-pem.git";
    rev = "07a683505d4a0a1113c4085c1ce117425d0afd80";
    sha256 = "e4a9396d90e50e8b3cceff45f312eda9aaf356423f4eddd354a0e1afbbfd4cf8";
  };

in

stdenv.mkDerivation rec {
  name = "nss-${version}";
  version = "3.13.6";

  src = let
    uscoreVersion = stdenv.lib.replaceChars ["."] ["_"] version;
    releasePath = "releases/NSS_${uscoreVersion}_RTM/src/nss-${version}.tar.gz";
  in fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/security/nss/${releasePath}";
    sha256 = "f7e90727e0ecc1c29de10da39a79bc9c53b814ccfbf40720e053b29c683d43a0";
  };

  buildInputs = [ nspr perl zlib sqlite ];

  postUnpack = ''
    cp -rdv "${nssPEM}/mozilla/security/nss/lib/ckfw/pem" \
            "$sourceRoot/mozilla/security/nss/lib/ckfw/"
    chmod -R u+w "$sourceRoot/mozilla/security/nss/lib/ckfw/pem"
  '';

  patches = [ ./nss-3.12.5-gentoo-fixups.diff ];

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

  postInstall =
    ''
      #find $out -name "*.a" | xargs rm
      rm -rf $out/private
      mv $out/public $out/include
      mv $out/*.OBJ/* $out/
      rmdir $out/*.OBJ
      ${if includeTools then "" else "rm -rf $out/bin"}

      # Borrowed from Gentoo.  Firefox expects an nss-config script,
      # but NSS doesn't provide it.

      NSS_VMAJOR=`cat lib/nss/nss.h | grep "#define.*NSS_VMAJOR" | awk '{print $3}'`
      NSS_VMINOR=`cat lib/nss/nss.h | grep "#define.*NSS_VMINOR" | awk '{print $3}'`
      NSS_VPATCH=`cat lib/nss/nss.h | grep "#define.*NSS_VPATCH" | awk '{print $3}'`

      ${if includeTools then "" else "mkdir $out/bin"}
      cp ${nssConfig} $out/bin/nss-config
      chmod u+x $out/bin/nss-config
      substituteInPlace $out/bin/nss-config \
        --subst-var-by MOD_MAJOR_VERSION $NSS_VMAJOR \
        --subst-var-by MOD_MINOR_VERSION $NSS_VMINOR \
        --subst-var-by MOD_PATCH_VERSION $NSS_VPATCH \
        --subst-var-by prefix $out \
        --subst-var-by exec_prefix $out \
        --subst-var-by includedir $out/include/nss \
        --subst-var-by libdir $out/lib
    ''; # */
}
