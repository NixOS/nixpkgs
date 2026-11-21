{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  parameterized,
  pygments,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mistletoe";
  version = "1.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "miyuchina";
    repo = "mistletoe";
    tag = "v${version}";
    hash = "sha256-L3jTPc5TZ/0oBUfoNoB/6QdUhMSlTsS5O6K18JrBhJE=";
  };

  pythonImportsCheck = [ "mistletoe" ];

  nativeCheckInputs = [
    parameterized
    pygments
    pytestCheckHook
  ];

  meta = {
    description = "Fast and extensible Markdown parser";
    mainProgram = "mistletoe";
    homepage = "https://github.com/miyuchina/mistletoe";
    changelog = "https://github.com/miyuchina/mistletoe/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eadwu ];
  };
}
