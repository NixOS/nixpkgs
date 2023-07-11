{ lib
, aiofiles
, buildPythonPackage
, cached-property
, colorama
, fetchFromGitHub
, git
, jsonschema
, pdm-backend
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "griffe";
  version = "0.31.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xN+zMNUKy/zeBnY9TAdllCV6E9UG6ke+jaXkOZ59HFI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'license = "ISC"' 'license = {file = "LICENSE"}' \
  '';

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    colorama
  ] ++ lib.optionals (pythonOlder "3.8") [
    cached-property
  ];

  nativeCheckInputs = [
    git
    jsonschema
    pytestCheckHook
  ];

  passthru.optional-dependencies = {
    async = [
      aiofiles
    ];
  };

  pythonImportsCheck = [
    "griffe"
  ];

  meta = with lib; {
    description = "Signatures for entire Python programs";
    homepage = "https://github.com/mkdocstrings/griffe";
    changelog = "https://github.com/mkdocstrings/griffe/blob/${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
