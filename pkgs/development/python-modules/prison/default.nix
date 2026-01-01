{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "prison";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "betodealmeida";
    repo = "python-rison";
    rev = version;
    hash = "sha256-qor40vUQeTdlO3vwug3GGNX5vkNaF0H7EWlRdsY4bvc=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "Rison encoder/decoder";
    homepage = "https://github.com/betodealmeida/python-rison";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Rison encoder/decoder";
    homepage = "https://github.com/betodealmeida/python-rison";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
