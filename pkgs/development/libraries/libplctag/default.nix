{ lib
, stdenv
, cmake
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "libplctag";
  version = "2.3.5";

  nativeBuildInputs = [ cmake ];

  src = fetchurl {
    url = "https://github.com/libplctag/libplctag/archive/v${version}.tar.gz";
    sha256 = "16azdxyl82js17xcav7v23zvi64w72181wylj489zim9x5h5sxsr";
  };

  meta = with lib; {
    homepage = "https://github.com/libplctag/libplctag";
    description = "Library that uses EtherNet/IP or Modbus TCP to read and write tags in PLCs";
    license = [ licenses.lgpl2Plus licenses.mpl20 ];
    maintainers = [ maintainers.petterstorvik ];
    platforms = platforms.all;
  };
}
