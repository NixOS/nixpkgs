{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "geniushub-client";
  version = "0.7.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "manzanotti";
    repo = "geniushub-client";
    tag = "v${version}";
    hash = "sha256-0qHmTq/nOPruivU5R8r0abmMAhxy0w5zILKFPxtL2Mc=";
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
