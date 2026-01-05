{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "cyrtranslit";
  version = "1.2.0";
  pyproject = true;

  # Pypi tarball doesn't contain tests/
  src = fetchFromGitHub {
    owner = "opendatakosovo";
    repo = "cyrillic-transliteration";
    tag = "v${version}";
    hash = "sha256-hE5fru9Y5gU4zG2Kz76w5HbVXKBua/cJdhItz3ou0kY=";
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
