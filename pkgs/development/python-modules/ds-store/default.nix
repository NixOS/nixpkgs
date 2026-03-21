{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mac-alias,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ds-store";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "al45tair";
    repo = "ds_store";
    tag = "v${version}";
    hash = "sha256-UqBZ6w9y+eOQ+OdhXJReT4GwaxEbrGFvmUQMrNyBdjU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ mac-alias ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ds_store" ];

  meta = {
    homepage = "https://github.com/al45tair/ds_store";
    description = "Manipulate Finder .DS_Store files from Python";
    mainProgram = "ds_store";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
