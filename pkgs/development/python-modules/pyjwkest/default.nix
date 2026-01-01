{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
  pycryptodomex,
  pytestCheckHook,
  requests,
  setuptools,
=======
  fetchPypi,
  future,
  pycryptodomex,
  pytest,
  requests,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  six,
}:

buildPythonPackage rec {
  pname = "pyjwkest";
<<<<<<< HEAD
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = "pyjwkest";
    tag = "v${version}";
    hash = "sha256-G4/qLOOQHsNSMVndUdYBhrrk8uEufbI8Od3ziQiY0XI=";
  };

  build-system = [ setuptools ];

  # Remove unused future import, see pending PR:
  # https://github.com/IdentityPython/pyjwkest/pull/107
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"future"' ""
  '';

  dependencies = [
=======
  version = "1.4.2";
  format = "setuptools";

  meta = {
    description = "Implementation of JWT, JWS, JWE and JWK";
    homepage = "https://github.com/rohe/pyjwkest";
    license = lib.licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "5560fd5ba08655f29ff6ad1df1e15dc05abc9d976fcbcec8d2b5167f49b70222";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [
    future
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pycryptodomex
    requests
    six
  ];
<<<<<<< HEAD

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jwkest" ];

  meta = {
    description = "Implementation of JWT, JWS, JWE and JWK";
    homepage = "https://github.com/IdentityPython/pyjwkest";
    license = lib.licenses.asl20;
  };
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
