{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "drawille";
  version = "0.2.0";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gVND4RYsWAUtTLZS75cPZ3Ht2QBC1UnsxuRTyXNqoa0=";
  };

  doCheck = false; # pypi package has no tests, git has no tags

  pythonImportsCheck = [ "drawille" ];

  meta = {
    description = "Drawing in terminal with unicode braille characters";
    homepage = "https://github.com/asciimoo/drawille";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ nobbz ];
    platforms = lib.platforms.all;
  };
}
