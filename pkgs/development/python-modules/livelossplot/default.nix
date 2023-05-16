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
<<<<<<< HEAD
  version = "0.5.5";

  disabled = pythonOlder "3.6";

=======
  version = "0.5.4";

  disabled = pythonOlder "3.6";

  # version number in source is wrong in this release
  postPatch = ''substituteInPlace ${pname}/version.py --replace "0.5.3" "0.5.4"'';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner  = "stared";
    repo   = pname;
    rev    = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-YU8vX4SubI6txmC/i5fOjcvWfuDFm8+SPmie8Eb1qRs=";
=======
    sha256 = "IV6YAidoqVoKvpy+LNNHTPpobiDoGX59bHqJcBtaydk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
