{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  fetchpatch2,
  setuptools,
  aiohttp,
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "doorbirdpy";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "klikini";
    repo = "doorbirdpy";
    rev = "refs/tags/${version}";
    hash = "sha256-6B4EMK41vEpmLoQLD+XN9yStLdxyHHk/Mym9J0o7Qvc=";
  };

  patches = [
    # https://gitlab.com/klikini/doorbirdpy/-/merge_requests/15
    (fetchpatch2 {
      name = "aiohttp-3.10-compat.patch";
      url = "https://gitlab.com/klikini/doorbirdpy/-/commit/91f417433be36a0c9d2baaf0d6ff1a45042f94eb.patch";
      hash = "sha256-b/ORH6ygkiBreWYTH7rP8b68HlFUEyLQCzVo1KLffPQ=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "doorbirdpy" ];

  meta = with lib; {
    changelog = "https://gitlab.com/klikini/doorbirdpy/-/tags/${version}";
    description = "Python wrapper for the DoorBird LAN API";
    homepage = "https://gitlab.com/klikini/doorbirdpy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
