{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mashumaro,
  requests,
}:

buildPythonPackage rec {
  pname = "py-opensonic";
<<<<<<< HEAD
  version = "7.0.4";
=======
  version = "7.0.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "khers";
    repo = "py-opensonic";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-5wsisIfYW+0uh0khUzt9wKFxBf/ZXVsKpNF/Dcrj2wI=";
=======
    hash = "sha256-t+MftumVBcIOO8WvWZcLXLp5Iq87Vpvqc4cxH+yTBAo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    mashumaro
    requests
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "libopensonic"
  ];

<<<<<<< HEAD
  meta = {
    description = "Python library to wrap the Open Subsonic REST API";
    homepage = "https://github.com/khers/py-opensonic";
    changelog = "https://github.com/khers/py-opensonic/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hexa ];
=======
  meta = with lib; {
    description = "Python library to wrap the Open Subsonic REST API";
    homepage = "https://github.com/khers/py-opensonic";
    changelog = "https://github.com/khers/py-opensonic/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
