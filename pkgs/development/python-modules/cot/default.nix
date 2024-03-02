{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, colorlog
, pyvmomi
, requests
, verboselogs
, pyopenssl
, setuptools
, mock
, pytest-mock
, pytestCheckHook
, qemu
}:

buildPythonPackage rec {
  pname = "cot";
  version = "2.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9LNVNBX5DarGVvidPoLnmz11F5Mjm7FzpoO0zAzrJjU=";
  };

  propagatedBuildInputs = [
    colorlog
    pyvmomi
    requests
    verboselogs
    pyopenssl
    setuptools
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
  '';

  disabledTests = [
    # Many tests require network access and/or ovftool (https://code.vmware.com/web/tool/ovf)
    # try enabling these tests with ovftool once/if it is added to nixpkgs
    "HelperGenericTest"
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
    "test_serial_fixup_stubbed_create"
    "test_serial_fixup_stubbed_vm_not_found"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_serial_fixup_invalid_host"
  ];

  pythonImportsCheck = [
    "COT"
  ];

  meta = with lib; {
    description = "Common OVF Tool";
    longDescription = ''
      COT (the Common OVF Tool) is a tool for editing Open Virtualization Format (.ovf, .ova) virtual appliances,
      with a focus on virtualized network appliances such as the Cisco CSR 1000V and Cisco IOS XRv platforms.
    '';
    homepage = "https://github.com/glennmatthews/cot";
    license = licenses.mit;
    maintainers = with maintainers; [ evanjs ];
  };
}
