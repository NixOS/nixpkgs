{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, nbformat
, mock
, pyyaml
, testfixtures
, notebook
}:

buildPythonPackage rec {
  pname = "jupytext";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0778a58bc45b0f96bd2559b51c3e451e8e52ef041e7d9c672d8b5595f662d0ce";
  };

  checkInputs = [ pytest notebook ];
  propagatedBuildInputs = [ nbformat mock pyyaml testfixtures ];

  checkPhase = ''
    pytest
  '';

  # not all test files included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Jupyter notebooks as Markdown documents, Julia, Python or R scripts";
    homepage = https://github.com/mwouts/jupytext;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
