{
  lib,
  buildPythonPackage,
  docutils,
  fetchPypi,
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
  version = "4.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Markups";
    inherit version;
    hash = "sha256-Pdua+xxV0M/4EuM5LKM/RoSYwHB6T6iy4F0LoNMsAZ4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    docutils
    markdown
    pygments
    python-markdown-math
    pyyaml
    textile
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

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
