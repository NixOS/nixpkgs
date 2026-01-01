{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pylru";
  version = "1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jlhutch";
    repo = "pylru";
    rev = "v${version}";
    hash = "sha256-dTYiD+/zt0ZSP+sefYyeD87To1nRXyoFodlBg8pm1YE=";
  };

  # Check with the next release if tests are ready
  doCheck = false;

  pythonImportsCheck = [ "pylru" ];

<<<<<<< HEAD
  meta = {
    description = "Least recently used (LRU) cache implementation";
    homepage = "https://github.com/jlhutch/pylru";
    license = lib.licenses.gpl2Only;
=======
  meta = with lib; {
    description = "Least recently used (LRU) cache implementation";
    homepage = "https://github.com/jlhutch/pylru";
    license = licenses.gpl2Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
