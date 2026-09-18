{
  lib,
  buildPythonPackage,
  colorlog,
  fetchPypi,
  mock,
  pytest-mock,
  pytestCheckHook,
  pyvmomi,
  qemu,
  requests,
  distutils,
  setuptools,
  standard-pkg-resources,
  stdenv,
  verboselogs,
  versioneer,
}:

buildPythonPackage (finalAttrs: {
  pname = "cot";
  version = "2.2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "cot";
    inherit (finalAttrs) version;
    hash = "sha256-9LNVNBX5DarGVvidPoLnmz11F5Mjm7FzpoO0zAzrJjU=";
  };

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    colorlog
    distutils
    pyvmomi
    requests
    standard-pkg-resources
    verboselogs
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-mock
    qemu
  ];

  prePatch = ''
    # argparse is part of the standardlib
    substituteInPlace setup.py \
      --replace "'argparse'," ""
    rm versioneer.py
  '';

  disabledTests = [
    # Many tests require network access and/or ovftool (https://code.vmware.com/web/tool/ovf)
    # try enabling these tests with ovftool once/if it is added to nixpkgs
    "TestCOTAddDisk"
    "TestCOTAddFile"
    "TestCOTEditHardware"
    "TestCOTEditProduct"
    "TestCOTEditProperties"
    "TestCOTInjectConfig"
    "TestISO"
    "TestOVFAPI"
    "TestQCOW2"
    "TestRAW"
    "TestVMDKConversion"
    # CLI test fails with AssertionError
    "test_help"
    # Failing TestCOTDeployESXi tests
    "test_serial_fixup_stubbed"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_serial_fixup_invalid_host" ];

  pythonImportsCheck = [ "COT" ];

  meta = {
    homepage = "https://github.com/glennmatthews/cot";
    description = "Common OVF Tool";
    mainProgram = "cot";
    longDescription = ''
      COT (the Common OVF Tool) is a tool for editing Open Virtualization Format
      (.ovf, .ova) virtual appliances, with a focus on virtualized network
      appliances such as the Cisco CSR 1000V and Cisco IOS XRv platforms.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evanjs ];
  };
})
