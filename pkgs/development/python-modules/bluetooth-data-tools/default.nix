{ lib
, buildPythonPackage
, fetchFromGitHub
, cryptography
, cython_3
, poetry-core
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "bluetooth-data-tools";
  version = "1.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zdMqjZ7CEwDnvVvIe1breQ+/4ZwzdLk2CtI+GCY+3uk=";
  };

  # The project can build both an optimized cython version and an unoptimized
  # python version. This ensures we fail if we build the wrong one.
  env.REQUIRE_CYTHON = 1;

  nativeBuildInputs = [
    cython_3
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
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
