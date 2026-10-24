{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "iso-639";
  version = "0.4.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3JzUuIC4mNd0xH/pd1FnQEr4qF3YidWPkAgDUQmszkk=";
  };

  propagatedBuildInputs = [ setuptools ];

  meta = {
    homepage = "https://github.com/noumar/iso639";
    description = "ISO 639 library for Python";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ zraexy ];
  };
}
