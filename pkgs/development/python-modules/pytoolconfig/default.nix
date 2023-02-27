{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build
, pdm-pep517

# docs
, docutils
, sphinxHook
, sphinx-rtd-theme
, sphinx-autodoc-typehints

# runtime
, tomli
, packaging

# optionals
, pydantic
, platformdirs
, sphinx
, tabulate

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytoolconfig";
  version = "1.2.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bagel897";
    repo = "pytoolconfig";
    rev = "refs/tags/v${version}";
    hash = "sha256-b7er/IgXr2j9dSnI87669BXWA5CXNTzwa1DTpl8PBZ4=";
  };

  outputs = [
    "out"
    "doc"
  ];

  PDM_PEP517_SCM_VERSION = version;

  nativeBuildInputs = [
    pdm-pep517

    # docs
    docutils
    sphinx-autodoc-typehints
    sphinx-rtd-theme
    sphinxHook
  ] ++ passthru.optional-dependencies.doc;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "packaging>=22.0" "packaging"
  '';

  propagatedBuildInputs = [
    packaging
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  passthru.optional-dependencies = {
    validation = [
      pydantic
    ];
    global = [
      platformdirs
    ];
    doc = [
      sphinx
      tabulate
    ];
  };

  pythonImportsCheck = [
    "pytoolconfig"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  meta = with lib; {
    changelog = "https://github.com/bagel897/pytoolconfig/releases/tag/v${version}";
    description = "Python tool configuration";
    homepage = "https://github.com/bagel897/pytoolconfig";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fab hexa ];
  };
}
