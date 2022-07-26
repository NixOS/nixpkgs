{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-levenshtein";
  version = "0.12.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc2395fbd148a1ab31090dd113c366695934b9e85fe5a4b2a032745efd0346f6";
  };

  # No tests included in archive
  doCheck = false;

  pythonImportsCheck = [
    "Levenshtein"
  ];

  meta = with lib; {
    description = "Functions for fast computation of Levenshtein distance and string similarity";
    homepage = "https://github.com/ztane/python-Levenshtein";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ aske ];
  };
}
