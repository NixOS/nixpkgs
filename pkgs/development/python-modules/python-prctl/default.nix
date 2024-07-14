{
  lib,
  buildPythonPackage,
  fetchPypi,
  libcap,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-prctl";
  version = "1.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tMqaJafU8azk//0fOi5k71II/gX5KfPt1eJwgcp+Z84=";
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
