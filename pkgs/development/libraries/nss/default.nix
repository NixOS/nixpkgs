{ stdenv, fetchurl, nspr, perl, zlib, includeTools ? false}:

let

  nssConfig = fetchurl {
    url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/dev-libs/nss/files/3.12-nss-config.in?rev=1.2";
    sha256 = "1ck9q68fxkjq16nflixbqi4xc6bmylmj994h3f1j42g8mp0xf0vd";
  };

in

stdenv.mkDerivation {
  name = "nss-3.12.7";
  
  src = fetchurl {
    url = http://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_12_7_RTM/src/nss-3.12.7.tar.gz;
    sha256 = "0x5h0r5hn4qzafxakhvqyw1r8r0zy09b7b0kmdh3ff6v29v4bnzx";
  };

  buildInputs = [nspr perl zlib];

  # Based on the build instructions at
  # http://www.mozilla.org/projects/security/pki/nss/nss-3.11.4/nss-3.11.4-build.html
  
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
