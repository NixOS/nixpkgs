{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  setuptools,
=======
  pythonOlder,
  setuptools,
  wheel,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "aioqsw";
<<<<<<< HEAD
  version = "0.4.2";
  pyproject = true;
=======
  version = "0.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "aioqsw";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-SIdEM5YxPnCM6wEJTL19t07Xb89wDAwHzKnz0dKC0tw=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];
=======
    hash = "sha256-h/rTwMF3lc/hWwpzCvK6UMq0rjq3xkw/tEY3BqOPS2s=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ aiohttp ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioqsw" ];

<<<<<<< HEAD
  meta = {
    description = "Library to fetch data from QNAP QSW switches";
    homepage = "https://github.com/Noltari/aioqsw";
    changelog = "https://github.com/Noltari/aioqsw/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library to fetch data from QNAP QSW switches";
    homepage = "https://github.com/Noltari/aioqsw";
    changelog = "https://github.com/Noltari/aioqsw/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
