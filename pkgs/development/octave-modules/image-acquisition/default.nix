{ buildOctavePackage
, lib
, fetchurl
, libv4l
, fltk
}:

buildOctavePackage rec {
  pname = "image-acquisition";
  version = "0.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1amp6npkddnnz2i5rm6gvn65qrbn0nxzl2cja3dvc2xqg396wrhh";
  };

  buildInputs = [
    libv4l
    fltk
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/image-acquisition/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Functions to capture images from connected devices";
    longDescription = ''
      The Octave-forge Image Aquisition package provides functions to
      capture images from connected devices. Currently only v4l2 is supported.
    '';
    # Got broke with octave 8.x update, and wasn't updated since 2015
    broken = true;
  };
}
