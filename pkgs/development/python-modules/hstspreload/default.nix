{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "hstspreload";
<<<<<<< HEAD
  version = "2025.12.3";
  pyproject = true;

=======
  version = "2025.1.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = "hstspreload";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-K44Lzom7AQMsnJGN9RYNfZuD+wbbZtTGStjJtS/4NcE=";
=======
    hash = "sha256-2KtQZroKhRzqFg0xL/gXMA3jP0FgYSPYy1eP3x78rQo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  # Tests require network connection
  doCheck = false;

  pythonImportsCheck = [ "hstspreload" ];

<<<<<<< HEAD
  meta = {
    description = "Chromium HSTS Preload list";
    homepage = "https://github.com/sethmlarson/hstspreload";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Chromium HSTS Preload list as a Python package and updated daily";
    homepage = "https://github.com/sethmlarson/hstspreload";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
