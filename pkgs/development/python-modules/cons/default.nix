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
  version = "0.4.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "python-cons";
    tag = "v${version}";
    hash = "sha256-BS7lThnv+dxtztvw2aRhQa8yx2cRfrZLiXjcwvZ8QR0=";
  };

  propagatedBuildInputs = [ logical-unification ];

  nativeCheckInputs = [
    py
    pytestCheckHook
    pytest-html
  ];

  pytestFlags = [
    "--html=testing-report.html"
    "--self-contained-html"
  ];

  pythonImportsCheck = [ "cons" ];

  meta = with lib; {
    description = "Implementation of Lisp/Scheme-like cons in Python";
    homepage = "https://github.com/pythological/python-cons";
    changelog = "https://github.com/pythological/python-cons/releases/tag/${src.tag}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Etjean ];
  };
}
