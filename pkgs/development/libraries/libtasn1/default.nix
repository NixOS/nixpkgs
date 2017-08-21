{ stdenv, fetchurl, perl, texinfo }:

stdenv.mkDerivation rec {
  name = "libtasn1-4.12";

  src = fetchurl {
    url = "mirror://gnu/libtasn1/${name}.tar.gz";
    sha256 = "0ls7jdq3y5fnrwg0pzhq11m21r8pshac2705bczz6mqjc8pdllv7";
  };

  patches = [
    (fetchurl {
      name = "CVE-2017-9310.patch";
      url = "https://git.savannah.gnu.org/gitweb/?p=libtasn1.git;a=patch;h=d8d805e1f2e6799bb2dff4871a8598dc83088a39";
      sha256 = "1v5w0dazp9qc2v7pc8b6g7s4dz5ak10hzrn35hx66q76yzrrzp7i";
    })
  ];

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  buildInputs = [ perl texinfo ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/libtasn1/;
    description = "An ASN.1 library";
    longDescription = ''
      Libtasn1 is the ASN.1 library used by GnuTLS, GNU Shishi and some
      other packages.  The goal of this implementation is to be highly
      portable, and only require an ANSI C89 platform.
    '';
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
