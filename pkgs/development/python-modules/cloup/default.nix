{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  click,
  setuptools-scm,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "cloup";
  version = "3.0.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+RwICnJRlt33T+q9YlAmb0Zul/wW3+Iadiz2vGvrPss=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ click ] ++ lib.optionals (pythonOlder "3.10") [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cloup" ];

  meta = with lib; {
    homepage = "https://github.com/janLuke/cloup";
    description = "Click extended with option groups, constraints, aliases, help themes";
    changelog = "https://github.com/janluke/cloup/releases/tag/v${version}";
    longDescription = ''
      Enriches Click with option groups, constraints, command aliases, help sections for subcommands, themes for --help and other stuff.
    '';
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
