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
  version = "0.8.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "python";
    rev = version;
    hash = "sha256-JGk6oJQ6mcLtn7SDtltsLPT+CxPZNRbq8bnY9pMcXHc=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    griffe
    mkdocstrings
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/mkdocstrings/python/blob/${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
