{stdenv, fetchurl, nspr, perl, zlib}:

stdenv.mkDerivation {
  name = "nss-3.12.3";
  
  src = fetchurl {
    url = http://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_12_3_RTM/src/nss-3.12.3.tar.bz2;
    sha1 = "eeca14a37629287baa10eb7562a5fb927e9dd171";
  };

  buildInputs = [nspr perl zlib];

  # Based on the build instructions at
  # http://www.mozilla.org/projects/security/pki/nss/nss-3.11.4/nss-3.11.4-build.html
  
  preConfigure = "cd mozilla/security/nss";

  BUILD_OPT = "1";

  makeFlags = "NSPR_CONFIG_STATUS= NSDISTMODE=copy BUILD_OPT=1 SOURCE_PREFIX=\$(out)";

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
      find $out -name "*.a" | xargs rm
      rm -rf $out/private
      mv $out/public $out/include
      mv $out/*.OBJ/* $out/
      rmdir $out/*.OBJ
    ''; # */
}
