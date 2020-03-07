{ lib, buildPythonPackage, fetchPypi, isPy27
, mock
, nbformat
, pytest
, pyyaml
}:

buildPythonPackage rec {
  pname = "jupytext";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jijf4a3iaskzi6frjwhd8drh7brn94r1zl7gni6d0dzr296mm93";
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
    homepage = "https://github.com/mwouts/jupytext";
    license = licenses.mit;
    maintainers = with maintainers; [ timokau ];
  };
}
