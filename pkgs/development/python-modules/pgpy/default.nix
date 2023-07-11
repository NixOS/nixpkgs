{ lib
, pythonOlder
, fetchFromGitHub
, buildPythonPackage
, setuptools
, pyasn1
, cryptography
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pgpy";
  version = "0.6.0";

  disabled = pythonOlder "3.6";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "SecurityInnovation";
    repo = "PGPy";
    rev = "v${version}";
    hash = "sha256-47YiHNxmjyCOYHHUV3Zyhs3Att9HZtCXYfbN34ooTxU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pyasn1
    cryptography
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/SecurityInnovation/PGPy";
    description = "Pretty Good Privacy for Python";
    longDescription = ''
      PGPy is a Python library for implementing Pretty Good Privacy into Python
      programs, conforming to the OpenPGP specification per RFC 4880.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu dotlambda ];
  };
}
