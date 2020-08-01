{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, isPy3k
, argcomplete, colorlog, pyvmomi, requests, verboselogs
, psutil, pyopenssl, setuptools
, mock, pytest, pytest-mock, pytestCheckHook, qemu
}:

buildPythonPackage rec {
  pname = "cot";
  version = "2.2.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4b3553415f90daac656f89d3e82e79b3d751793239bb173a683b4cc0ceb2635";
  };

  propagatedBuildInputs = [ colorlog pyvmomi requests verboselogs pyopenssl setuptools ]
  ++ stdenv.lib.optional (pythonOlder "3.3") psutil;

  checkInputs = [ mock pytestCheckHook pytest-mock qemu ];

  # Many tests require network access and/or ovftool (https://code.vmware.com/web/tool/ovf)
  # try enabling these tests with ovftool once/if it is added to nixpkgs
  disabledTests = [
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
  ];


  # argparse is part of the standardlib
  prePatch = ''
    substituteInPlace setup.py --replace "'argparse'," ""
  '';

  meta = with stdenv.lib; {
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
