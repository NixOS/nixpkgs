{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
}:

buildPythonPackage rec {
  pname = "astropy-helpers";
  version = "4.0.1";

  disabled = !isPy3k;

  doCheck = false; # tests requires sphinx-astropy

  src = fetchFromGitHub {
     owner = "astropy";
     repo = "astropy-helpers";
     rev = "v4.0.1";
     sha256 = "0nfy7zy8yshw0s7bs19g92wg4dm4jvi2lrk31yl8rji9w0izycij";
  };

  meta = with lib; {
    description = "Utilities for building and installing Astropy, Astropy affiliated packages, and their respective documentation";
    homepage = "https://github.com/astropy/astropy-helpers";
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
