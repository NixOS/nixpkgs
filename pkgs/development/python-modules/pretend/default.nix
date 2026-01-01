{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pretend";
  version = "1.0.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alex";
    repo = "pretend";
    rev = "v${version}";
    hash = "sha256-OqMfeIMFNBBLq6ejR3uOCIHZ9aA4zew7iefVlAsy1JQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pretend" ];

<<<<<<< HEAD
  meta = {
    description = "Module for stubbing";
    homepage = "https://github.com/alex/pretend";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Module for stubbing";
    homepage = "https://github.com/alex/pretend";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
