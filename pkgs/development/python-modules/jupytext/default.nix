{ lib, buildPythonPackage, fetchPypi, isPy27
, mock
, nbformat
, pytest
, pyyaml
}:

buildPythonPackage rec {
  pname = "jupytext";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e0b23c566dd3cf3a3a3bdcd880383d7fab79a5bbf0da6e5396818ac23a1ecf8a";
  };

  propagatedBuildInputs = [
    pyyaml
    nbformat
  ] ++ lib.optionals isPy27 [ mock ]; # why they put it in install_requires, who knows

  checkInputs = [
    pytest
  ];

  # requires test notebooks which are not shipped with the pypi release
  # also, pypi no longer includes tests
  doCheck = false;
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Jupyter notebooks as Markdown documents, Julia, Python or R scripts";
    homepage = https://github.com/mwouts/jupytext;
    license = licenses.mit;
    maintainers = with maintainers; [ timokau ];
  };
}
