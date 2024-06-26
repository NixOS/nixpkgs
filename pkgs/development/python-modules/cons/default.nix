{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  logical-unification,
  py,
  pytestCheckHook,
  pytest-html,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "cons";
  version = "0.4.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "python-cons";
    rev = "refs/tags/v${version}";
    hash = "sha256-XssERKiv4A8x7dZhLeFSciN6RCEfGs0or3PAQiYSPII=";
  };

  propagatedBuildInputs = [ logical-unification ];

  nativeCheckInputs = [
    py
    pytestCheckHook
    pytest-html
  ];

  pytestFlagsArray = [
    "--html=testing-report.html"
    "--self-contained-html"
  ];

  pythonImportsCheck = [ "cons" ];

  meta = with lib; {
    description = "Implementation of Lisp/Scheme-like cons in Python";
    homepage = "https://github.com/pythological/python-cons";
    changelog = "https://github.com/pythological/python-cons/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Etjean ];
  };
}
