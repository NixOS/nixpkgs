{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "filebytes";
  version = "0.10.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dkIC901551h/BLatRvfFBIXY8yxK7d0CIA8WUaCJJ0E=";
  };

  meta = with lib; {
    homepage = "https://scoding.de/filebytes-introduction";
    license = licenses.gpl2;
    description = "Scripts to parse ELF, PE, Mach-O and OAT (Android Runtime)";
    maintainers = with maintainers; [ bennofs ];
  };
}
