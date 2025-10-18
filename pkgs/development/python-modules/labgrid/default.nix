{
  ansicolors,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  grpcio,
  grpcio-tools,
  grpcio-reflection,
  jinja2,
  lib,
  mock,
  openssh,
  pexpect,
  psutil,
  pyserial,
  pytestCheckHook,
  pytest-benchmark,
  pytest-dependency,
  pytest-mock,
  pyudev,
  pyusb,
  pyyaml,
  requests,
  setuptools,
  setuptools-scm,
  xmodem,
}:

buildPythonPackage rec {
  pname = "labgrid";
  version = "25.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "labgrid-project";
    repo = "labgrid";
    tag = "v${version}";
    hash = "sha256-cLofkkp2T6Y9nQ5LIS7w9URZlt8DQNN8dm3NnrvcKWY=";
  };

  # Remove after package bump
  patches = [
    (fetchpatch {
      url = "https://github.com/Emantor/labgrid/commit/4a66b43882811d50600e37aa39b24ec40398d184.patch";
      hash = "sha256-eJMB1qFWiDzQXEB4dYOHYMQqCPHXEWCwWjNNY0yTC2s=";
    })
    (fetchpatch {
      url = "https://github.com/Emantor/labgrid/commit/d9933b3ec444c35d98fd41685481ecae8ff28bf4.patch";
      hash = "sha256-Zx5j+CD6Q89dLmTl5QSKI9M1IcZ97OCjEWtEbG+CKWE=";
    })
    (fetchpatch {
      url = "https://github.com/Emantor/labgrid/commit/f0b672afe1e8976c257f0adff9bf6e7ee9760d6f.patch";
      hash = "sha256-M7rg+W9SjWDdViWyWe3ERzbUowxzf09c4w1yG3jQGak=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    ansicolors
    attrs
    jinja2
    grpcio
    grpcio-tools
    grpcio-reflection
    pexpect
    pyserial
    pyudev
    pyusb
    pyyaml
    requests
    xmodem
  ];

  pythonRemoveDeps = [ "pyserial-labgrid" ];

  pythonImportsCheck = [ "labgrid" ];

  nativeCheckInputs = [
    mock
    openssh
    psutil
    pytestCheckHook
    pytest-benchmark
    pytest-mock
    pytest-dependency
  ];

  disabledtests = [
    # flaky, timing sensitive
    "test_timing"
  ];

  pytestFlags = [ "--benchmark-disable" ];

  meta = with lib; {
    description = "Embedded control & testing library";
    homepage = "https://github.com/labgrid-project/labgrid";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
