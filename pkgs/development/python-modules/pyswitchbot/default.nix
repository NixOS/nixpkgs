{
  lib,
<<<<<<< HEAD
  aiohttp,
  bleak,
  bleak-retry-connector,
=======
  bleak,
  bleak-retry-connector,
  boto3,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pyopenssl,
  pytest-asyncio,
  pytestCheckHook,
<<<<<<< HEAD
=======
  requests,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyswitchbot";
<<<<<<< HEAD
  version = "0.74.0";
=======
  version = "0.72.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-3n6ErE17W5Gsf/Isw4o45JcDihYUHendx8MLgh8gALk=";
=======
    hash = "sha256-QwCeq9EnE7oKqTtb6lmMcEw37dOK7WYbDEC984NujzY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
<<<<<<< HEAD
    aiohttp
    bleak
    bleak-retry-connector
    cryptography
    pyopenssl
=======
    bleak
    bleak-retry-connector
    boto3
    cryptography
    pyopenssl
    requests
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "switchbot" ];

  meta = {
    description = "Python library to control Switchbot IoT devices";
    homepage = "https://github.com/Danielhiversen/pySwitchbot";
    changelog = "https://github.com/Danielhiversen/pySwitchbot/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
}
