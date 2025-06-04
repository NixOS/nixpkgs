{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyspellchecker";
  version = "0.8.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "barrust";
    repo = "pyspellchecker";
    tag = "v${version}";
    hash = "sha256-cfYtUOXO4xzO2CYYhWMv3o40iw5/+nvA8MAzJn6LPlQ=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pure python spell checking";
    homepage = "https://github.com/barrust/pyspellchecker";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
