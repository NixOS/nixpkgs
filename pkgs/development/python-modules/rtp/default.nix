{
  lib,
  buildPythonPackage,
  fetchPypi,
  python3,

  # nativeCheckInputs
  hypothesis,
  unittestCheckHook,

}:

buildPythonPackage rec {
  pname = "rtp";
  version = "0.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I5k3uF5lSLDdCWjBEQC4kl2dWyAKcHEJIYwqnEvJDBI=";
  };

  nativeCheckInputs = [
    hypothesis
    unittestCheckHook
  ];

  unittestFlagsArray = [
    "-s"
    "tests"
    "-v"
  ];

  pythonImportsCheck = [ "rtp" ];

  meta = with lib; {
    description = "Library for decoding/encoding rtp packets";
    homepage = "https://github.com/bbc/rd-apmm-python-lib-rtp";
    license = licenses.asl20;
    maintainers = with maintainers; [ fleaz ];
  };
}
