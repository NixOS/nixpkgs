{
  lib,
  buildPythonPackage,
  isPyPy,
  fetchPypi,
  hatchling,
  hatch-vcs,
  gevent,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "execnet";
  version = "2.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UYm1LGEhwk/q4ogWarQbMlScfiNIZSc2VAuebn1OcuM=";
  };

  postPatch = ''
    # remove vbox tests
    rm testing/test_termination.py
    rm testing/test_channel.py
    rm testing/test_xspec.py
    rm testing/test_gateway.py
  ''
  + lib.optionalString isPyPy ''
    rm testing/test_multi.py
  '';

  build-system = [
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

  pytestFlags = [ "-vvv" ];

  pythonImportsCheck = [ "execnet" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Distributed Python deployment and communication";
    homepage = "https://execnet.readthedocs.io/";
    changelog = "https://github.com/pytest-dev/execnet/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
