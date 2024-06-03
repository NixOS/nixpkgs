{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "govee-local-api";
  version = "1.4.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Galorhallen";
    repo = "govee-local-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-kmIuo/e3eLJTgmI+2Oq9Y0jov/133jXwgoBayGv33r4=";
  };

  patches = [
    (fetchpatch2 {
      # configure pep517 build-backend
      url = "https://github.com/Galorhallen/govee-local-api/commit/897a21ae723ff94343bbf4ba1541e3a1d3e03c94.patch";
      hash = "sha256-/d5jGKGME768Ar+WWWQUByHJPGB31OHShI4oLjcMUIU=";
    })
  ];

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "govee_local_api" ];

  meta = with lib; {
    description = "Library to communicate with Govee local API";
    homepage = "https://github.com/Galorhallen/govee-local-api";
    changelog = "https://github.com/Galorhallen/govee-local-api/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
