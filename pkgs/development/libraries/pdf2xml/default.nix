{stdenv, fetchurl, libxpdf, libxml2}:

stdenv.mkDerivation {
  name = "pdf2xml";
  
  src = fetchurl {
      url = http://nixos.org/tarballs/pdf2xml.tar.gz;
      sha256 = "04rl7ppxqgnvxvvws669cxp478lnrdmiqj0g3m4p69bawfjc4z3w";
  };
  sourceRoot = "pdf2xml/pdf2xml";
  
  buildInputs = [libxml2 libxpdf];

  patches = [./pdf2xml.patch];

  preBuild = ''
    cp Makefile.linux Makefile
  
    sed -i 's|/usr/include/libxml2|${libxml2}/include/libxml2|' Makefile
    sed -i 's|-lxml2|-lxml2 -L${libxml2}/lib|' Makefile
    sed -i 's|XPDF = xpdf_3.01|XPDF = ${libxpdf}/lib|' Makefile

    mkdir exe
  '';
  
  installPhase = ''
    ensureDir $out/bin
    cp exe/* $out/bin
  '';
}
