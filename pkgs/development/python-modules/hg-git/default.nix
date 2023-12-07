{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, dulwich
, mercurial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hg-git";
  version = "1.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HuFwRW/SuGrzMX9bttdqztFRB19dZZNF5Y8+e9gAQWw=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dulwich
    mercurial
  ];

  pythonImportsCheck = [
    "hggit"
  ];

  meta = with lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = "https://hg-git.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ koral ];
  };
}
