{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  click,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "cloup";
  version = "3.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+RwICnJRlt33T+q9YlAmb0Zul/wW3+Iadiz2vGvrPss=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cloup" ];

  meta = {
    homepage = "https://github.com/janLuke/cloup";
    description = "Click extended with option groups, constraints, aliases, help themes";
    changelog = "https://github.com/janluke/cloup/releases/tag/v${version}";
    longDescription = ''
      Enriches Click with option groups, constraints, command aliases, help sections for subcommands, themes for --help and other stuff.
    '';
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
