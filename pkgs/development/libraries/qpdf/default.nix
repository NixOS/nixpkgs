{ stdenv, fetchurl, fetchpatch, libjpeg, zlib, perl }:

let version = "8.2.1";
in
stdenv.mkDerivation rec {
  name = "qpdf-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qpdf/qpdf/${version}/${name}.tar.gz";
    sha256 = "1jdb0jj72fjdp6xip4m7yz31r5x13zs7h4smnxsycgw3vbmx6igl";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib libjpeg ];

  patches = [
    (fetchpatch {
      name = "CVE-2018-9918.patch";
      url = "https://github.com/qpdf/qpdf/commit/b4d6cf6836ce025ba1811b7bbec52680c7204223";
      sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
    })
  ];

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
    license = licenses.asl20; # as of 7.0.0, people may stay at artistic2
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.all;
  };
}
