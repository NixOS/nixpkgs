{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jaconv";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ikegami-yukino";
    repo = "jaconv";
    tag = "v${version}";
    hash = "sha256-9ruhOLaYNESeKOwJs3IN6ct66fSq7My9DOyA7/cH3d0=";
  };

  patches = [
    ./fix-packaging.patch
    ./use-pytest.patch
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jaconv" ];

  meta = {
    description = "Python Japanese character interconverter for Hiragana, Katakana, Hankaku and Zenkaku";
    homepage = "https://github.com/ikegami-yukino/jaconv";
    changelog = "https://github.com/ikegami-yukino/jaconv/blob/v${version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
