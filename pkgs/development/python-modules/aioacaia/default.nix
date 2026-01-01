{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioacaia";
<<<<<<< HEAD
  version = "0.1.18";
  pyproject = true;

=======
  version = "0.1.17";
  pyproject = true;

  disabled = pythonOlder "3.12";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "aioacaia";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ltqY1n7Kvpf518q+cL8u+Cyg9BHySb0dopxKNtUdoA4=";
=======
    hash = "sha256-y9NSHiB66ICR+qJcLOdddnkm+f5hd9Zbqamr1UCzdlk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  # Module only has a homebrew tests
  doCheck = false;

  pythonImportsCheck = [ "aioacaia" ];

  meta = {
    description = "Async implementation of pyacaia";
    homepage = "https://github.com/zweckj/aioacaia";
    changelog = "https://github.com/zweckj/aioacaia/releases/tag/${src.tag}";
<<<<<<< HEAD
    license = lib.licenses.agpl3Only;
=======
    license = lib.licenses.gpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [ fab ];
  };
}
