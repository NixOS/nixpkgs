{ lib
, buildPythonPackage
, isPyPy
, fetchPypi
, hatchling
, hatch-vcs
, gevent
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "execnet";
  version = "2.0.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zFm8RCN0L9ca0icSLrDdRNtR77PcQJW0WsmgjHcAlq8=";
  };

  postPatch = ''
    # remove vbox tests
    rm testing/test_termination.py
    rm testing/test_channel.py
    rm testing/test_xspec.py
    rm testing/test_gateway.py
  '' + lib.optionalString isPyPy ''
    rm testing/test_multi.py
  '';

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  # sometimes crashes with: OSError: [Errno 9] Bad file descriptor
  doCheck = !isPyPy;

  nativeCheckInputs = [
    gevent
    pytestCheckHook
  ];

  disabledTests = [
    # gets stuck
    "test_popen_io"
    # OSError: [Errno 9] Bad file descriptor
    "test_stdouterrin_setnull"
  ];

  pytestFlagsArray = [ "-vvv" ];

  pythonImportsCheck = [
    "execnet"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://github.com/pytest-dev/execnet/blob/v${version}/CHANGELOG.rst";
    description = "Distributed Python deployment and communication";
    homepage = "https://execnet.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
