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
  version = "2.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "no-plagiarism";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-AIAccIxv3lCZcTKHfE/s2n3A5fUWqon+dk0SvczritY=";
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
