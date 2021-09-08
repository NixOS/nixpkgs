{ absl-py
, buildPythonPackage
, dm-tree
, fetchPypi
, isPy3k
, lib
, numpy
, tabulate
, tensorflow
, wrapt
}:

buildPythonPackage rec {
  pname = "dm-sonnet";
  version = "2.0.0";
  format  = "wheel";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit version format;
    pname = "dm_sonnet";
    dist = "py3";
    python = "py3";
    sha256 = "sha256:042bj4d75ka5yamscbqhladrrxnnrp1awsq2h2pcma30a29n8fbp";
  };

  propagatedBuildInputs = [
    absl-py
    dm-tree
    numpy
    tabulate
    wrapt
  ];

  # The wheel does not contain the official test suite. Unfortunately, we cannot
  # use pythonImportsCheckHook because sonnet requires tensorflow, although it
  # is not in the requirements.txt. Furthermore, checkInputs are not available
  # in the pythonImportsCheckHook phase. The tensorflow dependency is
  # intentionally elided since the user may want to select, eg. tensorflow-gpu.
  checkInputs = [ tensorflow ];
  checkPhase = ''
    python -c "import sonnet"
  '';

  meta = with lib; {
    description = "Sonnet is a library for building neural networks in TensorFlow.";
    homepage    = "https://sonnet.dev";
    license     = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
  };
}
