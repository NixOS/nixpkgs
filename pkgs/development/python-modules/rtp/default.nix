{
  lib,
  buildPythonPackage,
  fetchPypi,

  # nativeCheckInputs
  hypothesis,
  unittestCheckHook,

}:

buildPythonPackage (finalAttrs: {
  pname = "rtp";
  version = "0.0.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "rtp";
    inherit (finalAttrs) version;
    hash = "sha256-I5k3uF5lSLDdCWjBEQC4kl2dWyAKcHEJIYwqnEvJDBI=";
  };

  nativeCheckInputs = [
    hypothesis
    unittestCheckHook
  ];

  unittestFlags = [
    "--start-directory=tests"
    "-v"
  ];

  pythonImportsCheck = [ "rtp" ];

  meta = {
    description = "Library for decoding/encoding rtp packets";
    homepage = "https://github.com/bbc/rd-apmm-python-lib-rtp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fleaz ];
  };
})
