{ stdenv, fetchurl, perl, texinfo }:

stdenv.mkDerivation rec {
  name = "libtasn1-4.16.0";

  src = fetchurl {
    url = "mirror://gnu/libtasn1/${name}.tar.gz";
    sha256 = "179jskl7dmfp1rd2khkzmlibzgki4wi6hvmmwfv7q49r728b03qf";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  nativeBuildInputs = [ texinfo perl ];

  doCheck = true;
  preCheck = if stdenv.isDarwin then
    "export DYLD_LIBRARY_PATH=`pwd`/lib/.libs"
  else
    null;

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/libtasn1/;
    description = "An ASN.1 library";
    longDescription = ''
      Libtasn1 is the ASN.1 library used by GnuTLS, GNU Shishi and some
      other packages.  The goal of this implementation is to be highly
      portable, and only require an ANSI C89 platform.
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
  };
}
