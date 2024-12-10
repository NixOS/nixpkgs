{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libx86";
  version = "1.1";
  src = fetchurl {
    url = "https://www.codon.org.uk/~mjg59/libx86/downloads/${pname}-${version}.tar.gz";
    sha256 = "0j6h6bc02c6qi0q7c1ncraz4d1hkm5936r35rfsp4x1jrc233wav";
  };
  patches = [
    ./constants.patch
    ./non-x86.patch
  ];

  # using BACKEND=x86emu on 64bit systems fixes:
  #  http://www.mail-archive.com/suspend-devel@lists.sourceforge.net/msg02355.html
  makeFlags = [
    "DESTDIR=$(out)"
  ] ++ lib.optional (!stdenv.isi686) "BACKEND=x86emu";

  preBuild = ''
    sed -i lrmi.c -e 's@defined(__i386__)@(defined(__i386__) || defined(__x86_64__))@'
    sed -e s@/usr@@ -i Makefile
  '';

  meta = with lib; {
    description = "Real-mode x86 code emulator";
    maintainers = with maintainers; [ raskin ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    license = licenses.mit;
  };
}
