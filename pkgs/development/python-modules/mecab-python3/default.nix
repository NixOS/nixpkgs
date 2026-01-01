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
<<<<<<< HEAD
  version = "1.0.12";
=======
  version = "1.0.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "mecab_python3";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-mroeVu+A3ZcUfcv441CBR68Sn7Rs7A5DK4X5apvapLk=";
=======
    hash = "sha256-Ic1EFgQ+mpk/z7mG3ek+Q2agdUPdlYSbXvLlDJqa/M4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    mecab # for mecab-config
    swig
    setuptools-scm
  ];

  buildInputs = [ mecab ];

  doCheck = false;

  pythonImportsCheck = [ "MeCab" ];

<<<<<<< HEAD
  meta = {
    description = "Python wrapper for mecab: Morphological Analysis engine";
    homepage = "https://github.com/SamuraiT/mecab-python3";
    changelog = "https://github.com/SamuraiT/mecab-python3/releases/tag/v${version}";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Python wrapper for mecab: Morphological Analysis engine";
    homepage = "https://github.com/SamuraiT/mecab-python3";
    changelog = "https://github.com/SamuraiT/mecab-python3/releases/tag/v${version}";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      gpl2
      lgpl21
      bsd3
    ]; # any of the three
  };
}
