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
  version = "2.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "no-plagiarism";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-qYZm88wNOyZBb2Qhdpw83Oh679/dkWmrL/hQYsgEsaM=";
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
