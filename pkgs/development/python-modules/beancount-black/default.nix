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
  version = "1.0.5";

  disabled = pythonOlder "3.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beancount-black";
    tag = version;
    hash = "sha256-vo11mlgDhyc8YFnULJ4AFrANWmGpAMNX5jJ6QaUNqk0=";
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
