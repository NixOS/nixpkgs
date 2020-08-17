{ stdenv
, fetchurl
, cmake
}:

stdenv.mkDerivation rec {
  pname = "liborigin";
  version = "3.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/liborigin/liborigin/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.gz";
    sha256 = "19i05x9fgjvcwc0l1by3l2n1ag6qfbvwkpqap6mx3bnlz3w0grmy";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with stdenv.lib; {
    description = "A library for reading OriginLab OPJ project files";
    homepage = "https://sourceforge.net/projects/liborigin/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.doronbehar ];
    platforms = platforms.all;
  };
}
