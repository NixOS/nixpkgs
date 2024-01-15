{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
, packaging
, pdm-backend
, platformdirs
, pydantic
, pytestCheckHook
, pythonOlder
, sphinx
, sphinx-autodoc-typehints
, sphinx-rtd-theme
, sphinxHook
, tabulate
, tomli
}:

buildPythonPackage rec {
  pname = "pytoolconfig";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bagel897";
    repo = "pytoolconfig";
    rev = "refs/tags/v${version}";
    hash = "sha256-V7dANGnvhBhRy8IyO/gg73BMwpWRaV/xTF8JmRC7DPA=";
  };

  outputs = [
    "out"
    "doc"
  ];

  PDM_PEP517_SCM_VERSION = version;

  nativeBuildInputs = [
    pdm-backend

    # docs
    docutils
    sphinx-autodoc-typehints
    sphinx-rtd-theme
    sphinxHook
  ] ++ passthru.optional-dependencies.doc;

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
    description = "Python tool configuration";
    homepage = "https://github.com/bagel897/pytoolconfig";
    changelog = "https://github.com/bagel897/pytoolconfig/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fab hexa ];
  };
}
