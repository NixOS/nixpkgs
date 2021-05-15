{ lib, stdenv, buildPythonPackage, fetchPypi, isPyPy, isPy3k
, olefile, freetype, libjpeg, zlib, libtiff, libwebp, tcl, lcms2, tk, libX11
, openjpeg, libimagequant, pyroma, numpy, pytestCheckHook
}@args:

import ./generic.nix (rec {
  pname = "Pillow";
  version = "6.2.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l5rv8jkdrb5q846v60v03mcq64yrhklidjkgwv6s1pda71g17yv";
  };

  meta = with lib; {
    homepage = "https://python-pillow.org/";
    description = "The friendly PIL fork (Python Imaging Library)";
    longDescription = ''
      The Python Imaging Library (PIL) adds image processing
      capabilities to your Python interpreter.  This library
      supports many file formats, and provides powerful image
      processing and graphics capabilities.
    '';
    license = "http://www.pythonware.com/products/pil/license.htm";
    maintainers = with maintainers; [ goibhniu prikhi SuperSandro2000 ];
    knownVulnerabilities = [
      "CVE-2020-10177"
      "CVE-2020-10378"
      "CVE-2020-10379"
      "CVE-2020-10994"
      "CVE-2020-11538"
      "CVE-2020-35653"
      "CVE-2020-35654"
      "CVE-2020-35655"
      "CVE-2021-25289"
      "CVE-2021-25290"
      "CVE-2021-25291"
      "CVE-2021-25292"
      "CVE-2021-25293"
      "CVE-2021-27921"
      "CVE-2021-27922"
      "CVE-2021-27923"
    ];
  };
} // args )
