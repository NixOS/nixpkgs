{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-levenshtein";
  version = "0.20.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TFB7HibeKTdBU5gvpHfOp0Ht8JXYknczQ7SWG+rKyDQ=";
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
