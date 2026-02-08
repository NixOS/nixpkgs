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
  version = "1.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "miyuchina";
    repo = "mistletoe";
    tag = "v${version}";
    hash = "sha256-jFU16vdASGVSPq+TJ/6cN7IGkE/61SL9BWCOPsVqNaU=";
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
    changelog = "https://github.com/miyuchina/mistletoe/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eadwu ];
  };
}
