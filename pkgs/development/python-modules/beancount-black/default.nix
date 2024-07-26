{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  beancount-parser,
  click,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "beancount-black";
  version = "1.0.4";

  disabled = pythonOlder "3.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beancount-black";
    rev = "refs/tags/${version}";
    hash = "sha256-GrdQCxVsAzCusxxfQHF48doWG8OVrqBayCFof9RHTkE=";
  };

  buildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    beancount-parser
    click
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "beancount_black" ];

  meta = with lib; {
    description = "Opinioned code formatter for Beancount";
    mainProgram = "bean-black";
    homepage = "https://github.com/LaunchPlatform/beancount-black/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ambroisie ];
  };
}
