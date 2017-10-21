{ stdenv, fetchurl, pcre, zlib, perl }:

let version = "6.0.0";
in
stdenv.mkDerivation rec {
  name = "qpdf-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qpdf/qpdf/${version}/${name}.tar.gz";
    sha256 = "0csj2p2gkxrc0rk8ykymlsdgfas96vzf1dip3y1x7z1q9plwgzd9";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ pcre zlib ];

  postPatch = ''
    patchShebangs qpdf/fix-qdf
  '';

  preCheck = ''
    patchShebangs qtest/bin/qtest-driver
  '';

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://qpdf.sourceforge.net/;
    description = "A C++ library and set of programs that inspect and manipulate the structure of PDF files";
    license = licenses.artistic2;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.all;
  };
}
