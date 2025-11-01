{
  lib,
  babel,
  buildPythonPackage,
  fetchFromGitHub,
  linetable,
  pytestCheckHook,
  pythonOlder,
  hatchling,
}:

buildPythonPackage rec {
  pname = "kajiki";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jackrosenthal";
    repo = "kajiki";
    tag = "v${version}";
    hash = "sha256-bAgUMA9PlwsO7FRjwiKCsFffLWNU+Go1DToblmyWprk=";
  };

  propagatedBuildInputs = [ linetable ];

  build-system = [ hatchling ];

  nativeCheckInputs = [
    babel
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kajiki" ];

  meta = with lib; {
    description = "Module provides fast well-formed XML templates";
    mainProgram = "kajiki";
    homepage = "https://github.com/nandoflorestan/kajiki";
    changelog = "https://github.com/jackrosenthal/kajiki/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
