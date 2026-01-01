{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "cyrtranslit";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  # Pypi tarball doesn't contain tests/
  src = fetchFromGitHub {
    owner = "opendatakosovo";
    repo = "cyrillic-transliteration";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-hE5fru9Y5gU4zG2Kz76w5HbVXKBua/cJdhItz3ou0kY=";
=======
    hash = "sha256-t8UTOmjGqjmxU7+Po0/HmOPWAvcgZibaUC9dMlttA/0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "cyrtranslit" ];

<<<<<<< HEAD
  meta = {
    description = "Transliterate Cyrillic script to Latin script and vice versa";
    homepage = "https://github.com/opendatakosovo/cyrillic-transliteration";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
=======
  meta = with lib; {
    description = "Transliterate Cyrillic script to Latin script and vice versa";
    homepage = "https://github.com/opendatakosovo/cyrillic-transliteration";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

}
