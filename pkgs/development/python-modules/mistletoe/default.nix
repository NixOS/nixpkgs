{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  parameterized,
  pygments,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mistletoe";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "miyuchina";
    repo = "mistletoe";
    rev = "refs/tags/v${version}";
    hash = "sha256-MMBfH4q5AtC/azQUj1a1tMz1MdUf4ad5/tl7lcQCTOw=";
  };

  pythonImportsCheck = [ "mistletoe" ];

  nativeCheckInputs = [
    parameterized
    pygments
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Fast and extensible Markdown parser";
    mainProgram = "mistletoe";
    homepage = "https://github.com/miyuchina/mistletoe";
    changelog = "https://github.com/miyuchina/mistletoe/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
