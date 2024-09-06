{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "cyrtranslit";
  version = "1.1.1";
  pyproject = true;

  # Pypi tarball doesn't contain tests/
  src = fetchFromGitHub {
    owner = "opendatakosovo";
    repo = "cyrillic-transliteration";
    rev = "refs/tags/v${version}";
    hash = "sha256-t8UTOmjGqjmxU7+Po0/HmOPWAvcgZibaUC9dMlttA/0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "cyrtranslit" ];

  meta = with lib; {
    description = "Transliterate Cyrillic script to Latin script and vice versa";
    homepage = "https://github.com/opendatakosovo/cyrillic-transliteration";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };

}
