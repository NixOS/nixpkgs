{
  lib,
  buildPythonPackage,
  django,
  django-stubs-ext,
  fetchPypi,
  mypy,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tomli,
  types-pytz,
  types-pyyaml,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "django-stubs";
  version = "4.2.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jM0v9O5a3yK547expRbS4cIZHp2U5nLDXMK8PdYeD2s=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    django
    django-stubs-ext
    types-pytz
    types-pyyaml
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  passthru.optional-dependencies = {
    compatible-mypy = [ mypy ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "django-stubs" ];

  meta = with lib; {
    description = "PEP-484 stubs for Django";
    homepage = "https://github.com/typeddjango/django-stubs";
    changelog = "https://github.com/typeddjango/django-stubs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
