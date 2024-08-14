{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pendulum,
  phonenumbers,
  pycountry,
  python-ulid,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pydantic-extra-types";
  version = "2.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-extra-types";
    rev = "refs/tags/v${version}";
    hash = "sha256-YNr3eKwlPmLpYp0Z4WAOmWNMjta22ZZMuSlONkONxZU=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ pydantic ];

  passthru.optional-dependencies = {
    all = [
      pendulum
      phonenumbers
      pycountry
      python-ulid
    ];
  };

  pythonImportsCheck = [ "pydantic_extra_types" ];

  nativeCheckInputs = [ pytestCheckHook ] ++ passthru.optional-dependencies.all;

  meta = with lib; {
    changelog = "https://github.com/pydantic/pydantic-extra-types/blob/${src.rev}/HISTORY.md";
    description = "Extra Pydantic types";
    homepage = "https://github.com/pydantic/pydantic-extra-types";
    license = licenses.mit;
    maintainers = [ ];
  };
}
