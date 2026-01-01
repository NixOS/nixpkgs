{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "bitstruct";
    tag = version;
    hash = "sha256-r2FPfSoW1Za7kglwpPXnWvWwzhAB8fQXiLPmbsi/8Ps=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "bitstruct" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  meta = {
    description = "Python bit pack/unpack package";
    homepage = "https://github.com/eerimoq/bitstruct";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jakewaksbaum ];
=======
  meta = with lib; {
    description = "Python bit pack/unpack package";
    homepage = "https://github.com/eerimoq/bitstruct";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
