{
  buildOctavePackage,
  lib,
  fetchurl,
  libv4l,
  fltk,
}:

buildOctavePackage rec {
  pname = "image-acquisition";
  version = "0.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-Uehwk68GZ/M4WL5M3GF++mCPUg3M08Y0gkdO36/yhNI=";
  };

  buildInputs = [
    fltk
  ];

  propagatedBuildInputs = [
    libv4l
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/image-acquisition/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Functions to capture images from connected devices";
    longDescription = ''
      The Octave-forge Image Aquisition package provides functions to
      capture images from connected devices. Currently only v4l2 is supported.
    '';
  };
}
