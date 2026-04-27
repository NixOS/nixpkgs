{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pyflexit";
  version = "0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Sabesto";
    repo = "pyflexit";
    rev = version;
    sha256 = "1ajlqr3z6zj4fyslqzpwpfkvh8xjx94wsznzij0vx0q7jp43bqig";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyflexit" ];

  meta = {
    description = "Python library for Flexit A/C units";
    homepage = "https://github.com/Sabesto/pyflexit";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
