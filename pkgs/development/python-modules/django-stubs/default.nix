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
  version = "5.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "django_stubs";
    inherit version;
    hash = "sha256-B+JcLTy/9b5UAif/N3GcyJ8hXfqqpesDinWwG7+7JyI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools<79.0.0" setuptools
  '';

  build-system = [ setuptools ];

  dependencies = [
    django
    django-stubs-ext
    types-pytz
    types-pyyaml
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  optional-dependencies = {
    compatible-mypy = [ mypy ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "django-stubs" ];

  meta = with lib; {
    description = "PEP-484 stubs for Django";
    homepage = "https://github.com/typeddjango/django-stubs";
    changelog = "https://github.com/typeddjango/django-stubs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
