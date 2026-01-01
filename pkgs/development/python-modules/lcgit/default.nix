{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "lcgit";
<<<<<<< HEAD
  version = "3.0.0";
  pyproject = true;

=======
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "cisagov";
    repo = "lcgit";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-nCsTA0BKE/0afcqqqEx0mUrLOFbta14TPtNXHD67mas=";
=======
    hash = "sha256-s77Pq5VjXFyycVYwaomhdNWXKU4vGRJT6+t89UvGdn4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "lcgit" ];

<<<<<<< HEAD
  meta = {
    description = "Pythonic Linear Congruential Generator iterator";
    homepage = "https://github.com/cisagov/lcgit";
    changelog = "https://github.com/cisagov/lcgit/releases/tag/${src.tag}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Pythonic Linear Congruential Generator iterator";
    homepage = "https://github.com/cisagov/lcgit";
    changelog = "https://github.com/cisagov/lcgit/releases/tag/${src.tag}";
    license = licenses.cc0;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
