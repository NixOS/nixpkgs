{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "discovery30303";
  version = "0.3.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "discovery30303";
    tag = "v${version}";
    hash = "sha256-QIGLRe+nUV3tUOs+pu6Qk/2Amh9IVcQq89o2JeKiTvM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=discovery30303" ""
  '';

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

  pythonImportsCheck = [ "discovery30303" ];

  meta = with lib; {
    description = "Module to discover devices that respond on port 30303";
    homepage = "https://github.com/bdraco/discovery30303";
    changelog = "https://github.com/bdraco/discovery30303/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
