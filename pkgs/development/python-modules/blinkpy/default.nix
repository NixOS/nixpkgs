{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiofiles,
  aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  python-slugify,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  requests,
  setuptools,
  sortedcontainers,
}:

buildPythonPackage rec {
  pname = "blinkpy";
<<<<<<< HEAD
  version = "0.25.2";
  pyproject = true;

=======
  version = "0.24.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "fronzbot";
    repo = "blinkpy";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-pjOs9OLBXzhoQm2p0Kicw5BdobZIIEY7/RHX/2bj3qY=";
=======
    hash = "sha256-UjkVpXqGOOwtpBslQB61osaQvkuvD4A+xeUrMpyWetg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "wheel~=0.40.0" wheel \
      --replace-fail "setuptools>=68,<81" setuptools
  '';

<<<<<<< HEAD
  build-system = [ setuptools ];

  dependencies = [
=======
  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    aiofiles
    aiohttp
    python-dateutil
    python-slugify
    requests
    sortedcontainers
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "blinkpy"
    "blinkpy.api"
    "blinkpy.auth"
    "blinkpy.blinkpy"
    "blinkpy.camera"
    "blinkpy.helpers.util"
    "blinkpy.sync_module"
  ];

  meta = {
    description = "Python library for the Blink Camera system";
    homepage = "https://github.com/fronzbot/blinkpy";
    changelog = "https://github.com/fronzbot/blinkpy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
