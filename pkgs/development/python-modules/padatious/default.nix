{ lib
, buildPythonPackage
, fetchFromGitHub

# runtime
, fann2
, padaos
, xxhash

# tests
, pytestCheckHook
}:

let
  pname = "padatious";
  version = "0.4.8";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MycroftAI";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1vn/UyDSqM//eeSJSMk0ADDGgvCN6ksqty+M5Z+dxwg=";
  };

  propagatedBuildInputs = [
    fann2
    padaos
    xxhash
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # uses low timeouts
    "test_train_timeout_subprocess"
  ];

  pythonImportsCheck = [
    "padatious"
  ];

  meta = with lib; {
    description = "A neural network intent parser";
    longDescription = ''
      An efficient and agile neural network intent parser. Padatious is
      a core component of Mycroft AI.
    '';
    homepage = "https://github.com/MycroftAI/padatious";
    license = licenses.asl20;
  };
}
