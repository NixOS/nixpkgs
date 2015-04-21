{ stdenv, fetchurl, pcre, zlib, perl }:

let version = "5.1.2";
in
stdenv.mkDerivation rec {
  name = "qpdf-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qpdf/qpdf/${version}/${name}.tar.gz";
    sha256 = "1zbvhrp0zjzbi6q2bnbxbg6399r47pq5gw3kspzph81j19fqvpg9";
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
    maintainers = maintainers.abbradar;
    platforms = platforms.all;
  };
}
