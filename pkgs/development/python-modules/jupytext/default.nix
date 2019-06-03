{ lib
, buildPythonPackage
, fetchPypi
, testfixtures
, pyyaml
, mock
, nbformat
, pytest
}:

buildPythonPackage rec {
  pname = "jupytext";
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1klcx333kpgb5gbaasmz07brqjxvls3l5dpj0kv9cfsd76cq17yh";
  };

  propagatedBuildInputs = [
    pyyaml
    nbformat
    testfixtures
  ];
  checkInputs = [
    pytest
  ];
  # setup.py checks for those even though they're not needed at runtime (only
  # for tests), thus not propagated
  buildInputs = [
    mock
    pytest
  ];

  # requires test notebooks which are not shipped with the pypi release
  doCheck = false;
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Jupyter notebooks as Markdown documents, Julia, Python or R scripts";
    homepage = https://github.com/mwouts/jupytext;
    license = licenses.mit;
    maintainers = with maintainers; [ timokau ];
  };
}
