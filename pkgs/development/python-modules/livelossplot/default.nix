{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytest
, bokeh
, ipython
, matplotlib
, numpy
, nbconvert
, nbformat
}:

buildPythonPackage rec {
  pname = "livelossplot";
  version = "0.5.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner  = "stared";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "164v65qglgyg38q9ajnas99rp14mvrk5hn8x76b8iy81vszmx1c0";
  };

  propagatedBuildInputs = [ bokeh ipython matplotlib numpy ];

  checkInputs = [ pytest nbconvert nbformat ];
  checkPhase = ''
    pytest tests tests/external_test_examples.py
  '';

  meta = with lib; {
    description = "Live training loss plot in Jupyter for Keras, PyTorch, and others";
    homepage = "https://github.com/stared/livelossplot";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
