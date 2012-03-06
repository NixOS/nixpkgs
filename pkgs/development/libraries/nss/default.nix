{ stdenv, fetchurl, nspr, perl, zlib, includeTools ? false}:

let

  nssConfig = fetchurl {
    url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/dev-libs/nss/files/3.12-nss-config.in?rev=1.2";
    sha256 = "1ck9q68fxkjq16nflixbqi4xc6bmylmj994h3f1j42g8mp0xf0vd";
  };

in

stdenv.mkDerivation {
  name = "nss-3.13.3";

  src = fetchurl {
    url = http://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_13_3_RTM/src/nss-3.13.3.tar.gz;
    sha256 = "efa10f2c70da4bddabf1a6081964969bb23359b93d6eadbf4739274a77bc3587";
  };

  buildInputs = [nspr perl zlib];

  patches = [ ./nss-3.12.5-gentoo-fixups.diff ];

  # Based on the build instructions at
  # http://www.mozilla.org/projects/security/pki/nss/nss-3.11.4/nss-3.11.4-build.html

  postPatch = ''
    sed -i -e "/^PREFIX =/s:= /usr:= $out:" mozilla/security/nss/config/Makefile
  '';

  preConfigure = "cd mozilla/security/nss";

  BUILD_OPT = "1";

  makeFlags =
    [ "NSPR_CONFIG_STATUS=" "NSDISTMODE=copy" "BUILD_OPT=1" "SOURCE_PREFIX=\$(out)"
      "NSS_ENABLE_ECC=1"
    ]
    ++ stdenv.lib.optional stdenv.is64bit "USE_64=1";

  buildFlags = "nss_build_all";

  NIX_CFLAGS_COMPILE = "-I${nspr}/include/nspr";

  preBuild =
    ''
      # Fool it into thinking NSPR has already been built.
      touch build_nspr

      # Hack to make -lz dependencies work.
      touch cmd/signtool/-lz cmd/modutil/-lz
    '';

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
