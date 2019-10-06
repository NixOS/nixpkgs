{ lib, buildPythonPackage, fetchPypi, isPy27
, mock
, nbformat
, pytest
, pyyaml
}:

buildPythonPackage rec {
  pname = "jupytext";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a2c00bncf68havs3msra6jkx8frbv3yal56mk85wnkwhzlahj0c";
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
