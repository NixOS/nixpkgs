{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pycrc";
  version = "1.21";

  src = fetchPypi {
    pname = "PyCRC";
    inherit version;
    hash = "sha256-07DniLUB9Iri/27rNGUjQ8kJXkNWpl3yF+0ptR5ARbY=";
  };

  meta = with lib; {
    homepage = "https://github.com/cristianav/PyCRC";
    description = "Python libraries for CRC calculations (it supports CRC-16, CRC-32, CRC-CCITT, etc)";
    license = licenses.gpl3;
    maintainers = with maintainers; [ guibou ];
  };
}
