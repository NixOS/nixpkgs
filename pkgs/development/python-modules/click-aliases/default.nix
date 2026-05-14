{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  click,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "click-aliases";
  version = "1.0.5";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-aliases";
    rev = "v${version}";
    hash = "sha256-vR5MUbgQfgownnq/VuEB/Jreibh/SB8wbDWGOmareRU=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "click_aliases" ];

  meta = {
    homepage = "https://github.com/click-contrib/click-aliases";
    description = "Enable aliases for click";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ panicgh ];
  };
}
