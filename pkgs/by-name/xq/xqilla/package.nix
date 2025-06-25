{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  xercesc,
}:

stdenv.mkDerivation rec {
  pname = "xqilla";
  version = "2.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/xqilla/XQilla-${version}.tar.gz";
    sha256 = "0m9z7diw7pdyb4qycbqyr2x55s13v8310xsi7yz0inpw27q4vzdd";
  };

  patches = [
    (fetchpatch {
      name = "xqilla-gcc11.patch";
      url = "https://git.pld-linux.org/gitweb.cgi?p=packages/xqilla.git;a=blob_plain;f=xqilla-gcc11.patch;h=c9e28be64097040348f710cb27be5f7dad001112;hb=4efe07397c6fb426a65b2eec6999d3c7e683848a";
      hash = "sha256-enMEF3U+PsbwOQ5SwlRVWc/FpyLS3aK6JgUgOp3ZbiA=";
    })
  ];

  configureFlags = [
    "--with-xerces=${xercesc}"
    # code uses register storage specifier
    "CXXFLAGS=-std=c++14"
  ];

  buildInputs = [
    xercesc
  ];

  meta = with lib; {
    description = "XQuery and XPath 2 library and command line utility written in C++, implemented on top of the Xerces-C library";
    mainProgram = "xqilla";
    license = licenses.asl20;
    maintainers = with maintainers; [ obadz ];
    platforms = platforms.all;
  };
}
