{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
  git,
  lxml,
  rnc2rng,
}:

buildPythonPackage rec {
  pname = "citeproc-py";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2eOiJPk2/i5QM7XZ/9rKt2nO22HZbE4M8vC0iPHSS04=";
  };

  buildInputs = [ rnc2rng ];

  propagatedBuildInputs = [ lxml ];

  nativeCheckInputs = [
    nose
    git
  ];
  checkPhase = "nosetests tests";
  doCheck = false; # seems to want a Git repository, but fetchgit with leaveDotGit also fails
  pythonImportsCheck = [ "citeproc" ];

  meta = with lib; {
    homepage = "https://github.com/brechtm/citeproc-py";
    description = "Citation Style Language (CSL) parser for Python";
    mainProgram = "csl_unsorted";
    license = licenses.bsd2;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
