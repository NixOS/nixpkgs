{ lib
, buildPythonPackage
, fetchFromGitHub
, nix-update-script
, deprecated
, importlib-metadata
, pydantic_1
, ruamel-yaml
, semver
, types-deprecated
, setuptools
, setuptools-scm
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pydantic_yaml-0";
  version = "0.11.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "NowanIlfideme";
    repo = "pydantic-yaml";
    rev = "refs/tags/v${version}";
    hash = "sha256-AeUyVav0/k4Fz69Qizn4hcJKoi/CDR9eUan/nJhWsDY=";
  };

  postPatch = ''
    substituteInPlace src/pydantic_yaml/version.py \
      --replace-fail "0.0.0" "${version}"
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    deprecated
    importlib-metadata
    pydantic_1
    ruamel-yaml
    semver
    types-deprecated
  ];

  pythonImportsCheck = [
    "pydantic_yaml"
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A small helper library that adds some YAML capabilities to pydantic";
    homepage = "https://github.com/NowanIlfideme/pydantic-yaml";
    changelog = "https://github.com/NowanIlfideme/pydantic-yaml/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}

