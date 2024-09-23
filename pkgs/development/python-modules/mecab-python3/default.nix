{
  lib,
  buildPythonPackage,
  fetchPypi,
  mecab,
  swig,
  setuptools-scm,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mecab-python3";
  version = "1.0.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "mecab_python3";
    inherit version;
    hash = "sha256-LYkfSgEZ+3Zvp5bijYgaVXk6DDVE5EbP9k3JRq1yJ8w=";
  };

  nativeBuildInputs = [
    mecab # for mecab-config
    swig
    setuptools-scm
  ];

  buildInputs = [ mecab ];

  doCheck = false;

  pythonImportsCheck = [ "MeCab" ];

  meta = with lib; {
    description = "Python wrapper for mecab: Morphological Analysis engine";
    homepage = "https://github.com/SamuraiT/mecab-python3";
    changelog = "https://github.com/SamuraiT/mecab-python3/releases/tag/v${version}";
    license = with licenses; [
      gpl2
      lgpl21
      bsd3
    ]; # any of the three
  };
}
