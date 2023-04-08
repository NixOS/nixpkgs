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
  version = "0.26.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-p5JYBVvKvqKdYIYFh8ZiEgepJips9jg/6ao5yZ/fbcs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"' \
      --replace 'license = "ISC"' 'license = {file = "LICENSE"}' \
      --replace 'version = {source = "scm"}' 'license-expression = "ISC"'
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
