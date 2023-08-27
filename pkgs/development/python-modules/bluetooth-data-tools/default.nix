{ lib
, buildPythonPackage
, fetchFromGitHub
, cython_3
, poetry-core
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "bluetooth-data-tools";
  version = "1.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DLB2mBjHPVT2Fg2Kr0WUDuu5nqBCbdu525wAD3ERKV8=";
  };

  # The project can build both an optimized cython version and an unoptimized
  # python version. This ensures we fail if we build the wrong one.
  env.REQUIRE_CYTHON = 1;

  nativeBuildInputs = [
    cython_3
    poetry-core
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=bluetooth_data_tools --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "bluetooth_data_tools"
  ];

  meta = with lib; {
    description = "Library for converting bluetooth data and packets";
    homepage = "https://github.com/Bluetooth-Devices/bluetooth-data-tools";
    changelog = "https://github.com/Bluetooth-Devices/bluetooth-data-tools/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
