{
  alsa-lib,
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyalsaaudio";
  version = "0.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-p4qdyjNSSyyQZLNOIfWrh0JyMTzzJKmndZLzlqXg/dw=";
  };

  buildInputs = [
    alsa-lib
  ];

  pythonImportsCheck = [ "alsaaudio" ];

  # Unit tests exist in test.py, but they require hardware (and therefore /dev) access.
  doCheck = false;

  meta = {
    description = "ALSA wrappers for Python";
    homepage = "https://github.com/larsimmisch/pyalsaaudio";
    changelog = "https://github.com/larsimmisch/pyalsaaudio/blob/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ timschumi ];
  };
})
