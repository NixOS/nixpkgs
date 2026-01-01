{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiotractive";
<<<<<<< HEAD
  version = "0.7.0";
  pyproject = true;

=======
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "zhulik";
    repo = "aiotractive";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tdeRl3fY+OPlLnh/KixdKSy6WLIH/qQR3icoUkKGeGo=";
  };

  build-system = [ setuptools ];

  dependencies = [
=======
    hash = "sha256-QwwW/UxRgd4rco80SqQUGt0ArDNT9MXa/U/W2/dHZT0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    aiohttp
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiotractive" ];

<<<<<<< HEAD
  meta = {
    description = "Python client for the Tractive REST API";
    homepage = "https://github.com/zhulik/aiotractive";
    changelog = "https://github.com/zhulik/aiotractive/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    changelog = "https://github.com/zhulik/aiotractive/releases/tag/v${version}";
    description = "Python client for the Tractive REST API";
    homepage = "https://github.com/zhulik/aiotractive";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
