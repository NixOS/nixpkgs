{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyelectra";
  version = "1.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jafar-atili";
    repo = "pyelectra";
    tag = version;
    hash = "sha256-tSrm4KFzMuYf2VHLsDj5YMF6/aulaujxmnnIludKf08=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "electrasmart" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/jafar-atili/pyElectra/releases/tag/${version}";
    description = "Electra Smart Python Integration";
    homepage = "https://github.com/jafar-atili/pyelectra";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
