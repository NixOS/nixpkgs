{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gibberish-detector";
  version = "0.1.1";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "domanchi";
    repo = "gibberish-detector";
    rev = "v${version}";
    sha256 = "1si0fkpnk9vjkwl31sq5jkyv3rz8a5f2nh3xq7591j9wv2b6dn0b";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gibberish_detector" ];

<<<<<<< HEAD
  meta = {
    description = "Python module to detect gibberish strings";
    mainProgram = "gibberish-detector";
    homepage = "https://github.com/domanchi/gibberish-detector";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python module to detect gibberish strings";
    mainProgram = "gibberish-detector";
    homepage = "https://github.com/domanchi/gibberish-detector";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
