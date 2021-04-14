{ lib, buildPythonPackage, fetchPypi, isPy27
, markdown-it-py
, nbformat
, pytest
, pyyaml
, toml
}:

buildPythonPackage rec {
  pname = "jupytext";
  version = "1.11.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9062d001baaa32430fbb94a2c9394ac906db0a58da94e7aa4e414b73fd7d51bc";
  };

  propagatedBuildInputs = [
    markdown-it-py
    nbformat
    pyyaml
    toml
  ];

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
