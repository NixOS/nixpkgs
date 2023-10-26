{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, click
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-aliases";
  version = "1.0.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-aliases";
    rev = "v${version}";
    hash = "sha256-ZrNdxUMLRre0U9xCyyU8HjByNGMSXiuMDVjW9e88eyk=";
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
