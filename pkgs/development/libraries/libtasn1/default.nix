{ lib, stdenv, fetchurl, perl, texinfo }:

stdenv.mkDerivation rec {
  pname = "libtasn1";
  version = "4.18.0";

  src = fetchurl {
    url = "mirror://gnu/libtasn1/libtasn1-${version}.tar.gz";
    sha256 = "sha256-Q2XBVJU1Y9ZMZ6AktgfR7nXG23bg0PZXCeqAozTNGJg=";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  nativeBuildInputs = [ texinfo perl ];

  doCheck = true;
  preCheck = if stdenv.isDarwin then
    "export DYLD_LIBRARY_PATH=`pwd`/lib/.libs"
  else
    null;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/libtasn1/";
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
