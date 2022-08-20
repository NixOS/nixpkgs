{ stdenv
, lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pescea";
  version = "1.0.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lazdavila";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yiBtvD7kCqR/F4yoJa5rIOekYy8+zlJh849Jv+HkA4M=";
  };

  propagatedBuildInputs = [
    async-timeout
  ];

  checkInputs = [
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

  pythonImportsCheck = [
    "pescea"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Python interface to Escea fireplaces";
    homepage = "https://github.com/lazdavila/pescea";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
