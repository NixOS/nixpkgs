{ lib, pythonPackages }:

with pythonPackages;

buildPythonPackage rec {
  pname = "pandoc-xnos";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fBhzjImeTs7Fc9xlZavY1DKB/IlNQbgnQ9Ud893iUK4=";
  };

  doCheck = false;

  propagatedBuildInputs = [ pandocfilters psutil ];

  meta = with lib; {
    description = "Library for the pandoc-fignos/eqnos/tablenos/secnos Python Pandoc filters";
    homepage = "https://github.com/tomduck/pandoc-xnos";
    license = licenses.gpl3;
    maintainers = with maintainers; [ loicreynier ];
  };
}
