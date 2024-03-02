{ lib
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "iso3166";
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "deactivated";
    repo = "python-iso3166";
    rev = "refs/tags/v${version}";
    hash = "sha256-/y7c2qSA6+WKUP9YTSaMBjBxtqAuF4nB3MKvL5P6vL0=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "iso3166"
  ];

  meta = with lib; {
    description = "Self-contained ISO 3166-1 country definitions";
    homepage = "https://github.com/deactivated/python-iso3166";
    changelog = "https://github.com/deactivated/python-iso3166/blob/v${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ zraexy ];
  };
}
