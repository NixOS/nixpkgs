{ stdenv, fetchurl, perl, texinfo }:

stdenv.mkDerivation rec {
  name = "libtasn1-4.10";

  src = fetchurl {
    url = "mirror://gnu/libtasn1/${name}.tar.gz";
    sha256 = "00jsix5hny0g768zv4hk78dib7w0qmk5fbizf4jj37r51nd4s6k8";
  };

  patches = [
    (fetchurl {
      name = "CVE-2017-6891.patch";
      url = "https://git.savannah.gnu.org/gitweb/?p=libtasn1.git;a=patch;h=5520704d075802df25ce4ffccc010ba1641bd484";
      sha256 = "000r6wb87zkx8yhzkf1c3h7p5akwhjw51cv8f1yjnplrqqrr7h2k";
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
