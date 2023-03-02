{ lib
, fetchFromGitHub
, buildPythonPackage
, dawg-python
, docopt
, pytestCheckHook
, pymorphy3-dicts-ru
, pymorphy3-dicts-uk
}:

buildPythonPackage rec {
  pname = "pymorphy3";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "no-plagiarism";
    repo = pname;
    rev = version;
    hash = "sha256-5MXAYcjZPUrGf5G5e7Yml1SLukrZURA0TCv0GiP56rM=";
  };

  propagatedBuildInputs = [
    dawg-python
    docopt
    pymorphy3-dicts-ru
    pymorphy3-dicts-uk
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pymorphy3" ];

  meta = with lib; {
    description = "Morphological analyzer/inflection engine for Russian and Ukrainian";
    homepage = "https://github.com/no-plagiarism/pymorphy3";
    license = licenses.mit;
    maintainers = with maintainers; [ jboy ];
  };
}
