{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dirtyjson";
  version = "1.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kMpKGPP/MM6EnRANz0oAOVPHnTojSO8Fbx2cIiMaJf0=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dirtyjson" ];

  meta = {
    description = "JSON decoder for Python that can extract data from the muck";
    homepage = "https://github.com/codecobblers/dirtyjson";
    license = with lib.licenses; [
      afl21 # and
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
