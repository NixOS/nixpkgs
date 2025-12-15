{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "geniushub-client";
  version = "0.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "manzanotti";
    repo = "geniushub-client";
    tag = "v${version}";
    hash = "sha256-FkKdAVvG2+MmRamsDqWjAlmd/y4CX0fS/UrSTe6npA4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'VERSION = os.environ["GITHUB_REF_NAME"]' "" \
      --replace "version=VERSION," 'version="${version}",'
  '';

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "geniushubclient" ];

  meta = {
    description = "Module to interact with Genius Hub systems";
    homepage = "https://github.com/manzanotti/geniushub-client";
    changelog = "https://github.com/manzanotti/geniushub-client/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
