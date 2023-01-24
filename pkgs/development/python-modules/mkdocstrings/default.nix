{ lib
, buildPythonPackage
, fetchFromGitHub
, jinja2
, markdown
, markupsafe
, mkdocs
, mkdocs-autorefs
, pymdown-extensions
, pytestCheckHook
, pdm-pep517
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mkdocstrings";
  version = "0.19.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = pname;
    rev = version;
    sha256 = "sha256-VCWUV+3vXmKbAXImAqY/K4vsA64gHBg83VkxbJua/ao=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    jinja2
    markdown
    markupsafe
    mkdocs
    mkdocs-autorefs
    pymdown-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"' \
      --replace 'license = "ISC"' 'license = {text = "ISC"}'
  '';

  pythonImportsCheck = [
    "mkdocstrings"
  ];

  disabledTestPaths = [
    # Circular dependencies
    "tests/test_extension.py"
  ];

  meta = with lib; {
    description = "Automatic documentation from sources for MkDocs";
    homepage = "https://github.com/mkdocstrings/mkdocstrings";
    changelog = "https://github.com/mkdocstrings/mkdocstrings/blob/${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
