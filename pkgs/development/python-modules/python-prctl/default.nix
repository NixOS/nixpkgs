{ lib
, buildPythonPackage
, fetchPypi
, libcap
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-prctl";
  version = "1.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4ca9a25a7d4f1ace4fffd1f3a2e64ef5208fe05f929f3edd5e27081ca7e67ce";
  };

  buildInputs = [ libcap ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Intel MPX support was removed in GCC 9.1 & Linux kernel 5.6
    "test_mpx"

    # The Nix build sandbox has no_new_privs already enabled
    "test_no_new_privs"

    # The Nix build sandbox has seccomp already enabled
    "test_seccomp"

    # This will fail if prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_FORCE_DISABLE)
    # has been set system-wide, even outside the sandbox
    "test_speculation_ctrl"
  ];

  meta = {
    description = "Python(ic) interface to the linux prctl syscall";
    homepage = "https://github.com/seveas/python-prctl";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ catern ];
  };
}
