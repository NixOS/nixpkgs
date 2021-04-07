{ lib
, buildPythonPackage
, fetchPypi
, nose
, git
, lxml
, rnc2rng
}:

buildPythonPackage rec {
  pname = "citeproc-py";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00aaff50jy4j0nakdzq9258z1gzrac9baarli2ymgspj88jg5968";
  };

  buildInputs = [ rnc2rng ];

  propagatedBuildInputs = [ lxml ];

  checkInputs = [ nose git ];
  checkPhase = "nosetests tests";
  doCheck = false;  # seems to want a Git repository, but fetchgit with leaveDotGit also fails
  pythonImportsCheck = [ "citeproc" ];

  meta = with lib; {
    homepage = "https://github.com/brechtm/citeproc-py";
    description = "Citation Style Language (CSL) parser for Python";
    license = licenses.bsd2;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
