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

  meta = with lib; {
    description = "Drawing in terminal with unicode braille characters";
    homepage = "https://github.com/asciimoo/drawille";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ nobbz ];
    platforms = platforms.all;
  };
}
