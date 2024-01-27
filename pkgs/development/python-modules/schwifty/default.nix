{ lib
, buildPythonPackage
, fetchPypi

# build-system
, hatchling
, hatch-vcs

# dependencies
, iso3166
, pycountry

# optional-dependencies
, pydantic

# tests
, pytestCheckHook
, pytest-cov
, pythonOlder
}:

buildPythonPackage rec {
  pname = "schwifty";
  version = "2024.1.1.post0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZFDu+stuKdsVc8bTuSZ4LZX8BuQhORjyEMosnrk1rX0=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    iso3166
    pycountry
  ];

  passthru.optional-dependencies = {
    pydantic = [
      pydantic
    ];
  };

  nativeCheckInputs = [
    pytest-cov
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "schwifty"
  ];

  meta = with lib; {
    changelog = "https://github.com/mdomke/schwifty/blob/${version}/CHANGELOG.rst";
    description = "Validate/generate IBANs and BICs";
    homepage = "https://github.com/mdomke/schwifty";
    license = licenses.mit;
    maintainers = with maintainers; [ milibopp ];
  };
}
