{ lib, buildPythonPackage, fetchPypi, isPy27
, mock
, nbformat
, pytest
, pyyaml
, toml
}:

buildPythonPackage rec {
  pname = "jupytext";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23123b90c267c67716fe6a022dfae49b84fd3809370d83211f2920eb3106bf40";
  };

  propagatedBuildInputs = [
    pyyaml
    nbformat
    toml
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
