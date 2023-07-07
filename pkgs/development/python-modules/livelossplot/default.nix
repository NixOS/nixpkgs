{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, bokeh
, ipython
, matplotlib
, numpy
, nbconvert
, nbformat
}:

buildPythonPackage rec {
  pname = "livelossplot";
  version = "0.5.4";

  disabled = pythonOlder "3.6";

  # version number in source is wrong in this release
  postPatch = ''substituteInPlace ${pname}/version.py --replace "0.5.3" "0.5.4"'';

  src = fetchFromGitHub {
    owner  = "stared";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "IV6YAidoqVoKvpy+LNNHTPpobiDoGX59bHqJcBtaydk=";
  };

  propagatedBuildInputs = [ bokeh ipython matplotlib numpy ];

  nativeCheckInputs = [ nbconvert nbformat pytestCheckHook ];

  meta = with lib; {
    description = "Live training loss plot in Jupyter for Keras, PyTorch, and others";
    homepage = "https://github.com/stared/livelossplot";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
