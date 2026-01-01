{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "polling";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "justiniso";
    repo = "polling";
    rev = "v${version}";
    hash = "sha256-Qy2QxCWzAjZMJ6yxZiDT/80I2+rLimoG8/SYxq960Tk=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "polling" ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

<<<<<<< HEAD
  meta = {
    description = "Powerful polling utility in Python";
    homepage = "https://github.com/justiniso/polling";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Powerful polling utility in Python";
    homepage = "https://github.com/justiniso/polling";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
