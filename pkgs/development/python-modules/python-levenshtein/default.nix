{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-Levenshtein";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c9ybqcja31nghfcc8xxbbz9h60s9qi12b9hr4jyl69xbvg12fh3";
  };

  # No tests included in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Functions for fast computation of Levenshtein distance and string similarity";
    homepage    = "https://github.com/ztane/python-Levenshtein";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ aske ];
  };

}
