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
  version = "3.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ySsmHHu34TAEkw8/tLPtrY3i0fEplNzdvgW8IZkEQ8U=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ click ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

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
