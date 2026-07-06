{
  ansicolors,
  attrs,
  buildPythonPackage,
  exceptiongroup,
  fetchFromGitHub,
  fetchpatch,
  fetchpatch2,
  grpcio,
  grpcio-tools,
  grpcio-reflection,
  jinja2,
  lib,
  nix-update-script,
  mock,
  openssh,
  pexpect,
  psutil,
  pyserial,
  pytest,
  pytestCheckHook,
  pytest-benchmark,
  pytest-dependency,
  pytest-mock,
  pyudev,
  pyusb,
  pyyaml,
  py-netgear-plus,
  requests,
  setuptools,
  setuptools-scm,
  util-linux,
  xmodem,
}:

buildPythonPackage (finalAttrs: {
  pname = "labgrid";
  version = "26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "labgrid-project";
    repo = "labgrid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SX7FIaSl2sy1hMPEmgGCQQAzXUeFZRw/CrXf/ZHRBDU=";
  };

  passthru.updateScript = nix-update-script { };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    ansicolors
    attrs
    exceptiongroup
    jinja2
    grpcio
    grpcio-tools
    grpcio-reflection
    pexpect
    pyserial
    pyudev
    pyusb
    pyyaml
    pytest
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
    util-linux
    py-netgear-plus
  ];

  disabledTests = [
    # flaky, timing sensitive
    "test_timing"

    # flaky, depends on ssh connection
    "test_argument_device_expansion"
    "test_argument_file_expansion"
    "test_local_managedfile"

    # flaky: teardown race on x86_64-linux
    "test_remoteplace_target"

    # netns tests require working SSH & Agentwrapper
    "test_tcp"
    "test_udp"
    "test_getaddrinfo"
    "test_closed_socket"
    "test_dup"
    "test_detach"
    "test_socks"
  ];

  pytestFlags = [ "--benchmark-disable" ];

  meta = {
    description = "Embedded control & testing library";
    homepage = "https://github.com/labgrid-project/labgrid";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ emantor ];
    platforms = with lib.platforms; linux;
  };
})
