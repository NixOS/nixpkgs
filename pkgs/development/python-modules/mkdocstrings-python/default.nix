{ lib
, buildPythonPackage
, fetchFromGitHub
, griffe
, mkdocs-material
, mkdocstrings
, pdm-pep517
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mkdocstrings-python";
  version = "0.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "python";
    rev = version;
    hash = "sha256-KAVBK0ZR1R27cWH99DVOYNFWKa4ubBXzgM0hVpGRIpE=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    griffe
    mkdocstrings
  ];

  checkInputs = [
    mkdocs-material
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'license = "ISC"' 'license = {text = "ISC"}' \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  pythonImportsCheck = [
    "mkdocstrings_handlers"
  ];

  meta = with lib; {
    description = "Python handler for mkdocstrings";
    homepage = "https://github.com/mkdocstrings/python";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
