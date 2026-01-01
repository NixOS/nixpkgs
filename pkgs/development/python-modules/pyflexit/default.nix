{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyflexit";
  version = "0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Sabesto";
    repo = "pyflexit";
    rev = version;
    sha256 = "1ajlqr3z6zj4fyslqzpwpfkvh8xjx94wsznzij0vx0q7jp43bqig";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyflexit" ];

<<<<<<< HEAD
  meta = {
    description = "Python library for Flexit A/C units";
    homepage = "https://github.com/Sabesto/pyflexit";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python library for Flexit A/C units";
    homepage = "https://github.com/Sabesto/pyflexit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
