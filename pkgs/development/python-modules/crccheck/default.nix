{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "crccheck";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MartinScharrer";
    repo = "crccheck";
    tag = "v${version}";
    hash = "sha256-hT+8+moni7turn5MK719b4Xy336htyWWmoMnhgxKkYo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "crccheck" ];

<<<<<<< HEAD
  meta = {
    description = "Python library for CRCs and checksums";
    homepage = "https://github.com/MartinScharrer/crccheck";
    changelog = "https://github.com/MartinScharrer/crccheck/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Python library for CRCs and checksums";
    homepage = "https://github.com/MartinScharrer/crccheck";
    changelog = "https://github.com/MartinScharrer/crccheck/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
