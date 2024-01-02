{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, click
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-aliases";
  version = "1.0.3";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-aliases";
    rev = "v${version}";
    hash = "sha256-HTjo6ID27W7D4MZjeAJMSy5yVd6oKg0Ed9/kDtQZ7Vw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "click_aliases" ];

  meta = with lib; {
    homepage = "https://github.com/click-contrib/click-aliases";
    description = "Enable aliases for click";
    license = licenses.mit;
    maintainers = with maintainers; [ panicgh ];
  };
}
