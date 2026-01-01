{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hpack";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-hyper";
    repo = "hpack";
    rev = "v${version}";
    hash = "sha256-vbxfDlRDwMXuzkPO0oceCpSz1ekLNxLSj4iocdHo680=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hpack" ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/python-hyper/hpack/blob/${src.rev}/CHANGELOG.rst";
    description = "Pure-Python HPACK header compression";
    homepage = "https://github.com/python-hyper/hpack";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/python-hyper/hpack/blob/${src.rev}/CHANGELOG.rst";
    description = "Pure-Python HPACK header compression";
    homepage = "https://github.com/python-hyper/hpack";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
