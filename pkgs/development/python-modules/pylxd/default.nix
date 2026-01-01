{
  lib,
  buildPythonPackage,
  cryptography,
  ddt,
  fetchFromGitHub,
  mock-services,
  pytestCheckHook,
  python-dateutil,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  requests,
  urllib3,
  requests-toolbelt,
  requests-unixsocket,
  setuptools,
  ws4py,
}:

buildPythonPackage rec {
  pname = "pylxd";
<<<<<<< HEAD
  version = "2.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "pylxd";
    tag = version;
    hash = "sha256-UbDkau3TLwFxWZxJGNF5hgtGn6JgVq5L2CvUgnb4IC8=";
=======
  version = "2.3.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "canonica";
    repo = "pylxd";
    tag = version;
    hash = "sha256-Q4GMz7HFpJNPYlYgLhE0a7mVCwNpdbw4XVcUGQ2gUJ0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonRelaxDeps = [ "urllib3" ];

<<<<<<< HEAD
  build-system = [ setuptools ];

  dependencies = [
=======
  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    cryptography
    python-dateutil
    requests
    requests-toolbelt
    requests-unixsocket
    urllib3
    ws4py
  ];

  nativeCheckInputs = [
    ddt
    mock-services
    pytestCheckHook
  ];

  disabledTestPaths = [
    "integration"
    "migration"
  ];

  pythonImportsCheck = [ "pylxd" ];

<<<<<<< HEAD
  meta = {
    description = "Library for interacting with the LXD REST API";
    homepage = "https://pylxd.readthedocs.io/";
    changelog = "https://github.com/canonical/pylxd/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Library for interacting with the LXD REST API";
    homepage = "https://pylxd.readthedocs.io/";
    changelog = "https://github.com/canonical/pylxd/releases/tag/${version}";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
