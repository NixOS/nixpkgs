{ stdenv, fetchurl, pcre, zlib, perl }:

let version = "5.1.3";
in
stdenv.mkDerivation rec {
  name = "qpdf-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qpdf/qpdf/${version}/${name}.tar.gz";
    sha256 = "1lq1v7xghvl6p4hgrwbps3a13ad6lh4ib3myimb83hxgsgd4n5nm";
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

  meta = with stdenv.lib; {
    homepage = http://qpdf.sourceforge.net/; 
    description = "A C++ library and set of programs that inspect and manipulate the structure of PDF files";
    license = licenses.artistic2;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.all;
  };
}
