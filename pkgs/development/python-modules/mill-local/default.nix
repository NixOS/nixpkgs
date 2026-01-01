{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  setuptools,
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "mill-local";
<<<<<<< HEAD
  version = "0.5.0";
  pyproject = true;
=======
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyMillLocal";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-t6nZ6KXX5GFIcdNIXyFxYtSjOuuUJmCekaBITNgcIkU=";
  };

  buildInputs = [ setuptools ];

  dependencies = [
=======
    hash = "sha256-WPL9vPK625gs3IO2XMFRCD+J6dQSxmEqg6FsX+2RLNk=";
  };

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "mill_local" ];

<<<<<<< HEAD
  meta = {
    description = "Python module to communicate locally with Mill heaters";
    homepage = "https://github.com/Danielhiversen/pyMillLocal";
    changelog = "https://github.com/Danielhiversen/pyMillLocal/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python module to communicate locally with Mill heaters";
    homepage = "https://github.com/Danielhiversen/pyMillLocal";
    changelog = "https://github.com/Danielhiversen/pyMillLocal/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
