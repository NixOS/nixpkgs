{
  lib,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyisemail";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "michaelherold";
    repo = "pyIsEmail";
    tag = "v${version}";
    hash = "sha256-bJCaVUhvEAoQ8zMsbcb1Et728XHt+shEPhhBzPzY/vo=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ dnspython ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyisemail" ];

  meta = {
    description = "Module for email validation";
    homepage = "https://github.com/michaelherold/pyIsEmail";
    changelog = "https://github.com/michaelherold/pyIsEmail/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
