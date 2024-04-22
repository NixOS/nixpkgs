{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pynose
, pexpect
, pyserial
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pygatt";
  version = "4.0.5";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "peplin";
    repo = "pygatt";
    rev = "refs/tags/v${version}";
    hash = "sha256-DUZGsztZViVNZwmhXoRN5FOQ7BgUeI0SsYgCHlvsrv0=";
  };

  postPatch = ''
    # Not support for Python < 3.4
    substituteInPlace setup.py \
      --replace-fail "'enum-compat'" "" \
      --replace-fail "'coverage >= 3.7.1'," "" \
      --replace-fail "'nose >= 1.3.7'" ""
    substituteInPlace tests/bgapi/test_bgapi.py \
       --replace-fail "assertEquals" "assertEqual"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    pyserial
  ];

  passthru.optional-dependencies.GATTTOOL = [
    pexpect
  ];

  nativeBuildInputs = [
    # For cross compilation the doCheck is false and therefor the
    # nativeCheckInputs not included. We have to include nose here, since
    # setup.py requires nose unconditionally.
    pynose
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ passthru.optional-dependencies.GATTTOOL;

  pythonImportsCheck = [
    "pygatt"
  ];

  meta = with lib; {
    description = "Python wrapper the BGAPI for accessing Bluetooth LE Devices";
    homepage = "https://github.com/peplin/pygatt";
    changelog = "https://github.com/peplin/pygatt/blob/v${version}/CHANGELOG.rst";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ fab ];
  };
}
