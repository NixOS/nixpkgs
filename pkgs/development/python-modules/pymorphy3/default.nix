{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  click,
  dawg-python,
  docopt,
  pytestCheckHook,
  pymorphy3-dicts-ru,
  pymorphy3-dicts-uk,
}:

buildPythonPackage rec {
  pname = "pymorphy3";
  version = "2.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "no-plagiarism";
    repo = "pymorphy3";
    tag = version;
    hash = "sha256-Ula2OQ80dcGeMlXauehXnlEkHLjjm4jZn39eFNltbEA=";
  };

  propagatedBuildInputs = [
    dawg-python
    docopt
    pymorphy3-dicts-ru
    pymorphy3-dicts-uk
  ];

  optional-dependencies.CLI = [ click ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.CLI;

  pythonImportsCheck = [ "pymorphy3" ];

  meta = with lib; {
    description = "Morphological analyzer/inflection engine for Russian and Ukrainian";
    mainProgram = "pymorphy";
    homepage = "https://github.com/no-plagiarism/pymorphy3";
    license = licenses.mit;
    maintainers = with maintainers; [ jboy ];
  };
}
