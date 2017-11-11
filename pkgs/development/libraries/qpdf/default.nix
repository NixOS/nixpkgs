{ stdenv, fetchurl, libjpeg, pcre, zlib, perl }:

let version = "7.0.0";
in
stdenv.mkDerivation rec {
  name = "qpdf-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qpdf/qpdf/${version}/${name}.tar.gz";
    sha256 = "0py6p27fx4qrwq9mvcybna42b0bdi359x38lzmggxl5a9khqvl7y";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ pcre zlib libjpeg ];

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
