{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pescea";
  version = "1.0.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lazdavila";
    repo = pname;
    # https://github.com/lazdavila/pescea/issues/4
    rev = "a3dd7deedc64205e24adbc4ff406a2f6aed3b240";
    hash = "sha256-5TkFrGaSkQOORhf5a7SjkzggFLPyqe9k3M0B4ljhWTQ=";
  };

  propagatedBuildInputs = [ async-timeout ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    # https://github.com/lazdavila/pescea/pull/1
    substituteInPlace setup.py \
      --replace '"asyncio",' ""
  '';

  disabledTests = [
    # AssertionError: assert <State.BUSY: 'BusyWaiting'>...
    "test_updates_while_busy"
    # Test requires network access
    "test_flow_control"
  ];

  pythonImportsCheck = [ "pescea" ];

  meta = with lib; {
    description = "Python interface to Escea fireplaces";
    homepage = "https://github.com/lazdavila/pescea";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
