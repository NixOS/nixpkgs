{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  semver,
  pendulum,
  phonenumbers,
  pycountry,
  python-ulid,
  pytz,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pydantic-extra-types";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-extra-types";
    rev = "refs/tags/v${version}";
    hash = "sha256-PgytBSue3disJifnpTl1DGNMZkp93cJEIDm8wgKMHFo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pydantic
    semver
  ];

  optional-dependencies = {
    all = [
      pendulum
      phonenumbers
      pycountry
      python-ulid
      pytz
    ];
  };

  pythonImportsCheck = [ "pydantic_extra_types" ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.all;

  meta = with lib; {
    changelog = "https://github.com/pydantic/pydantic-extra-types/blob/${src.rev}/HISTORY.md";
    description = "Extra Pydantic types";
    homepage = "https://github.com/pydantic/pydantic-extra-types";
    license = licenses.mit;
    maintainers = [ ];
  };
}
