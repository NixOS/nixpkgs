{
  lib,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  importlib-metadata,
  markdown,
  pygments,
  pytestCheckHook,
  python-markdown-math,
  pythonOlder,
  pyyaml,
  setuptools,
  textile,
}:

buildPythonPackage rec {
  pname = "markups";
  version = "4.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "retext-project";
    repo = "pymarkups";
    tag = version;
    hash = "sha256-kQ1L8l/ONT4qOA/xfx85WyA7pDveaKoXWGZbljYxO/4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docutils
    markdown
    pygments
    python-markdown-math
    pyyaml
    textile
  ]
  ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # AssertionError: '.selector .ch { color: #408080' not found in 'pre...
    "test_get_pygments_stylesheet"
  ];

  pythonImportsCheck = [ "markups" ];

  meta = with lib; {
    description = "Wrapper around various text markup languages";
    homepage = "https://github.com/retext-project/pymarkups";
    license = licenses.bsd3;
    maintainers = with maintainers; [ klntsky ];
  };
}
