{ stdenv, fetchurl, libjpeg, zlib, perl }:

let version = "9.1.1";
in
stdenv.mkDerivation rec {
  pname = "qpdf";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/qpdf/qpdf/${version}/${pname}-${version}.tar.gz";
    sha256 = "0dj27wb9xg6pg95phbflfvy9rwxn1gh3kc4n175g0pf41r0zrim2";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib libjpeg ];

  postPatch = ''
    patchShebangs qpdf/fix-qdf
  '';

  preCheck = ''
    patchShebangs qtest/bin/qtest-driver
  '';

  doCheck = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://qpdf.sourceforge.net/";
    description = "A C++ library and set of programs that inspect and manipulate the structure of PDF files";
    license = licenses.asl20; # as of 7.0.0, people may stay at artistic2
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.all;
  };
}
