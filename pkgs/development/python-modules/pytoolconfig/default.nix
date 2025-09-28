{
  lib,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  packaging,
  pdm-backend,
  platformdirs,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,
  sphinxHook,
  tabulate,
  tomli,
}:

buildPythonPackage rec {
  pname = "pytoolconfig";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bagel897";
    repo = "pytoolconfig";
    tag = "v${version}";
    hash = "sha256-h21SDgVsnCDZQf5GS7sFE19L/p+OlAFZGEYKc0RHn30=";
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
  ]
  ++ optional-dependencies.doc;

  propagatedBuildInputs = [ packaging ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  optional-dependencies = {
    validation = [ pydantic ];
    global = [ platformdirs ];
    doc = [
      sphinx
      tabulate
    ];
  };

  pythonImportsCheck = [ "pytoolconfig" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  meta = with lib; {
    description = "Python tool configuration";
    homepage = "https://github.com/bagel897/pytoolconfig";
    changelog = "https://github.com/bagel897/pytoolconfig/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [
      fab
      hexa
    ];
  };
}
