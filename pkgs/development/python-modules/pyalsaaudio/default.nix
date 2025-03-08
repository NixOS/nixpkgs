{
  alsa-lib,
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "pyalsaaudio";
  version = "0.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p4qdyjNSSyyQZLNOIfWrh0JyMTzzJKmndZLzlqXg/dw=";
  };

  buildInputs = [
    alsa-lib
  ];

  pythonImportsCheck = [ "alsaaudio" ];

  # Unit tests exist in test.py, but they require hardware (and therefore /dev) access.
  doCheck = false;

  meta = with lib; {
    description = "ALSA wrappers for Python";
    homepage = "https://github.com/larsimmisch/pyalsaaudio";
    changelog = "https://github.com/larsimmisch/pyalsaaudio/blob/${version}/CHANGES.md";
    license = licenses.psfl;
    maintainers = with maintainers; [ timschumi ];
  };
}
