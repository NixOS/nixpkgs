{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "jasper";
  version = "2.0.28";

  src = fetchFromGitHub {
    owner = "jasper-software";
    repo = pname;
    rev = "version-${version}";
    hash = "sha256-f3UG5w8GbwZcsFBaQN6v8kdEkKIGgizcAgaVZtKwS78=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    homepage = "https://jasper-software.github.io/jasper/";
    description = "Image processing/coding toolkit";
    longDescription = ''
      JasPer is a software toolkit for the handling of image data. The software
      provides a means for representing images, and facilitates the manipulation
      of image data, as well as the import/export of such data in numerous
      formats (e.g., JPEG-2000 JP2, JPEG, PNM, BMP, Sun Rasterfile, and
      PGX). The import functionality supports the auto-detection (i.e.,
      automatic determination) of the image format, eliminating the need to
      explicitly identify the format of coded input data. A simple color
      management engine is also provided in order to allow the accurate
      representation of color. Partial support is included for the ICC color
      profile file format, an industry standard for specifying color.

      The JasPer software consists of a library and several application
      programs. The code is written in the C programming language. This language
      was chosen primarily due to the availability of C development environments
      for most computing platforms when JasPer was first developed, circa 1999.
    '';
    license = licenses.free; # MIT-like
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
