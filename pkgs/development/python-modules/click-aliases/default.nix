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
  version = "1.0.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-aliases";
    rev = "v${version}";
    hash = "sha256-nHUvzUiWc7Fq22PPsodIDOwU1INy2CQfztD0ceguhEo=";
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
