{
  lib,
  aiohttp,
  bleak,
<<<<<<< HEAD
  bleak-retry-connector,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildPythonPackage,
  fetchFromGitHub,
  async-timeout,
  setuptools,
}:

buildPythonPackage rec {
  pname = "adax-local";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyAdaxLocal";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-8gVpUYQoE4V3ATR6zFAz/sARyEmHu9lYyGchTpS1eX8=";
=======
    hash = "sha256-HdhatjlN4oUzBV1cf/PfgOJbEks4KBdw4vH8Y/z6efQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bleak
<<<<<<< HEAD
    bleak-retry-connector
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    async-timeout
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "adax_local" ];

<<<<<<< HEAD
  meta = {
    description = "Module for local access to Adax";
    homepage = "https://github.com/Danielhiversen/pyAdaxLocal";
    changelog = "https://github.com/Danielhiversen/pyAdaxLocal/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module for local access to Adax";
    homepage = "https://github.com/Danielhiversen/pyAdaxLocal";
    changelog = "https://github.com/Danielhiversen/pyAdaxLocal/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
