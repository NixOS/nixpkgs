{
  lib,
  pythonOlder,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pyasn1,
  cryptography,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pgpy";
  version = "0.6.0";

  disabled = pythonOlder "3.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "SecurityInnovation";
    repo = "PGPy";
    rev = "v${version}";
    hash = "sha256-47YiHNxmjyCOYHHUV3Zyhs3Att9HZtCXYfbN34ooTxU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyasn1
    cryptography
  ];

  patches = [
    # https://github.com/SecurityInnovation/PGPy/issues/462
    ./pr-443.patch

    # https://github.com/SecurityInnovation/PGPy/pull/474
    ./Fix-compat-with-current-cryptography.patch
  ];

  postPatch = ''
    # https://github.com/SecurityInnovation/PGPy/issues/472
    substituteInPlace tests/test_10_exceptions.py \
      --replace-fail ", 512" ", 1024" # We need longer test key because pgp deprecated length=512
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/SecurityInnovation/PGPy";
    description = "Pretty Good Privacy for Python";
    longDescription = ''
      PGPy is a Python library for implementing Pretty Good Privacy into Python
      programs, conforming to the OpenPGP specification per RFC 4880.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      eadwu
      dotlambda
    ];
  };
}
