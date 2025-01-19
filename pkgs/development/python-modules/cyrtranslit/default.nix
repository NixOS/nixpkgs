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
    tag = "v${version}";
    hash = "sha256-t8UTOmjGqjmxU7+Po0/HmOPWAvcgZibaUC9dMlttA/0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "cyrtranslit" ];

  meta = {
    description = "Transliterate Cyrillic script to Latin script and vice versa";
    homepage = "https://github.com/opendatakosovo/cyrillic-transliteration";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
  };

}
