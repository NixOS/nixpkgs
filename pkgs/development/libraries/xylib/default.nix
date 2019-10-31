{ stdenv, fetchurl, boost, zlib, bzip2, wxGTK30 }:

stdenv.mkDerivation rec {
  pname = "xylib";
  version = "1.5";

  src = fetchurl {
    url = "https://github.com/wojdyr/xylib/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "1r2kx80zhdvz39k6h2fsncm2742xxvxl3z8a3fnr13jl9sl7mnnd";
  };

  buildInputs = [ boost zlib bzip2 wxGTK30 ];

  meta = with stdenv.lib; {
    description = "Portable library for reading files that contain x-y data from powder diffraction, spectroscopy and other experimental methods";
    license = licenses.lgpl21;
    homepage = http://xylib.sourceforge.net/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
