{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # Python deps
  attrs,
  cbor2,
  certvalidator,
  cryptography,
  ecdsa,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cose";
  version = "1.1.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "TimothyClaeys";
    repo = "pycose";
    rev = "v${version}";
    hash = "sha256-HgGGmOvBadLDTAEkUY6aLC7r0aGKGfQv/Zyl8Orh8U0=";
  };

  propagatedBuildInputs = [
    attrs
    cbor2
    certvalidator
    cryptography
    ecdsa
    setuptools
  ];

  pythonImportsCheck = [ "pycose" ];

<<<<<<< HEAD
  meta = {
    description = "Python implementation of the COSE specification";
    homepage = "https://github.com/TimothyClaeys/pycose";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ t4ccer ];
=======
  meta = with lib; {
    description = "Python implementation of the COSE specification";
    homepage = "https://github.com/TimothyClaeys/pycose";
    license = licenses.bsd3;
    maintainers = with maintainers; [ t4ccer ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
