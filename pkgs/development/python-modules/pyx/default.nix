{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyx";
  version = "0.16";
  disabled = !isPy3k;

  src = fetchPypi {
    pname = "PyX";
    inherit version;
    sha256 = "sha256-TY4+RxzT6am9E9UIbN98CvGww/PhledPX2MxjcQKZtg=";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Python package for the generation of PostScript, PDF, and SVG files";
    homepage = "https://pyx.sourceforge.net/";
    license = with licenses; [ gpl2 ];
  };
}
